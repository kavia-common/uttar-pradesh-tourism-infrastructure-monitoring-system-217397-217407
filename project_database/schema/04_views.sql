-- 04_views.sql
-- Analytical and summary views

-- Project overview: status, budgets, funds received, payments made, milestone progress
CREATE OR REPLACE VIEW v_project_overview AS
SELECT
    p.id AS project_id,
    p.project_code,
    p.name AS project_name,
    p.status,
    p.estimated_cost,
    p.approved_budget,
    COALESCE(f.total_funds, 0) AS total_funds_sanctioned,
    COALESCE(pay.total_payments, 0) AS total_payments_made,
    COALESCE(mstat.milestones_total, 0) AS milestones_total,
    COALESCE(mstat.milestones_completed, 0) AS milestones_completed,
    ROUND(COALESCE(mstat.progress_avg, 0)::numeric, 2) AS avg_progress_percent,
    p.start_date,
    p.end_date,
    p.location_id
FROM projects p
LEFT JOIN (
    SELECT project_id, SUM(sanctioned_amount) AS total_funds
    FROM funds
    GROUP BY project_id
) f ON f.project_id = p.id
LEFT JOIN (
    SELECT project_id, SUM(amount) AS total_payments
    FROM payments
    WHERE status IN ('PAID', 'PROCESSING')
    GROUP BY project_id
) pay ON pay.project_id = p.id
LEFT JOIN (
    SELECT 
        m.project_id,
        COUNT(*) AS milestones_total,
        SUM(CASE WHEN m.status = 'COMPLETED' THEN 1 ELSE 0 END) AS milestones_completed,
        AVG(COALESCE(mu.progress_percent, CASE WHEN m.status='COMPLETED' THEN 100 ELSE 0 END)) AS progress_avg
    FROM milestones m
    LEFT JOIN LATERAL (
        SELECT mu1.progress_percent
        FROM milestone_updates mu1
        WHERE mu1.milestone_id = m.id
        ORDER BY mu1.update_date DESC, mu1.id DESC
        LIMIT 1
    ) mu ON TRUE
    GROUP BY m.project_id
) mstat ON mstat.project_id = p.id;

-- Fund utilization: funds sanctioned vs payments
CREATE OR REPLACE VIEW v_fund_utilization AS
SELECT
    p.id AS project_id,
    p.project_code,
    p.name AS project_name,
    COALESCE(funds.total_funds, 0) AS total_funds,
    COALESCE(pay.total_paid, 0) AS total_paid,
    CASE 
        WHEN COALESCE(funds.total_funds, 0) = 0 THEN 0
        ELSE ROUND(100.0 * COALESCE(pay.total_paid, 0) / funds.total_funds, 2)
    END AS utilization_percent
FROM projects p
LEFT JOIN (
    SELECT project_id, SUM(sanctioned_amount) AS total_funds
    FROM funds
    GROUP BY project_id
) funds ON funds.project_id = p.id
LEFT JOIN (
    SELECT project_id, SUM(amount) AS total_paid
    FROM payments
    WHERE status = 'PAID'
    GROUP BY project_id
) pay ON pay.project_id = p.id;

-- Contractor performance: contract value, total paid, number of projects, avg rating and milestone completion
CREATE OR REPLACE VIEW v_contractor_performance AS
SELECT
    c.id AS contractor_id,
    c.name AS contractor_name,
    c.rating,
    COUNT(DISTINCT ct.id) AS contracts_count,
    COUNT(DISTINCT p.id) AS projects_count,
    COALESCE(SUM(ct.value), 0) AS total_contract_value,
    COALESCE(SUM(pay.amount), 0) AS total_paid_amount,
    ROUND(AVG(CASE WHEN m.status='COMPLETED' THEN 100 ELSE COALESCE(mu.progress_percent, 0) END)::numeric, 2) AS avg_progress_percent
FROM contractors c
LEFT JOIN contracts ct ON ct.contractor_id = c.id
LEFT JOIN tenders t ON t.id = ct.tender_id
LEFT JOIN projects p ON p.id = t.project_id
LEFT JOIN milestones m ON m.project_id = p.id
LEFT JOIN LATERAL (
    SELECT mu1.progress_percent
    FROM milestone_updates mu1
    WHERE mu1.milestone_id = m.id
    ORDER BY mu1.update_date DESC, mu1.id DESC
    LIMIT 1
) mu ON TRUE
LEFT JOIN payments pay ON pay.contract_id = ct.id AND pay.status IN ('PAID','PROCESSING')
GROUP BY c.id, c.name, c.rating;

-- Geographic progress (lat/long used; PostGIS alternative can replace)
CREATE OR REPLACE VIEW v_geo_progress AS
SELECT
    p.id AS project_id,
    p.project_code,
    p.name AS project_name,
    p.status,
    p.latitude AS proj_lat,
    p.longitude AS proj_lon,
    s.id AS site_id,
    s.name AS site_name,
    s.latitude AS site_lat,
    s.longitude AS site_lon,
    mu.update_date,
    mu.progress_percent,
    mu.status AS milestone_status
FROM projects p
LEFT JOIN sites s ON s.project_id = p.id
LEFT JOIN LATERAL (
    SELECT mu1.*
    FROM milestones m1
    JOIN milestone_updates mu1 ON mu1.milestone_id = m1.id
    WHERE m1.project_id = p.id
    ORDER BY mu1.update_date DESC, mu1.id DESC
    LIMIT 1
) mu ON TRUE;
