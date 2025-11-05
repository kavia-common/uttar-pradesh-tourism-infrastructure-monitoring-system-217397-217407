-- 02_constraints.sql
-- Constraints, indexes, and additional integrity rules

-- Unique constraints where appropriate
ALTER TABLE contractors
    ADD CONSTRAINT IF NOT EXISTS uq_contractors_registration UNIQUE (registration_no);

ALTER TABLE tenders
    ADD CONSTRAINT IF NOT EXISTS uq_tenders_tender_no UNIQUE (tender_no);

ALTER TABLE contracts
    ADD CONSTRAINT IF NOT EXISTS uq_contracts_contract_no UNIQUE (contract_no);

-- Check constraints
ALTER TABLE payments
    DROP CONSTRAINT IF EXISTS chk_payments_amount_positive,
    ADD CONSTRAINT chk_payments_amount_positive CHECK (amount >= 0);

ALTER TABLE funds
    DROP CONSTRAINT IF EXISTS chk_funds_sanctioned_nonneg,
    ADD CONSTRAINT chk_funds_sanctioned_nonneg CHECK (sanctioned_amount >= 0);

ALTER TABLE milestones
    DROP CONSTRAINT IF EXISTS chk_milestones_amount_nonneg,
    ADD CONSTRAINT chk_milestones_amount_nonneg CHECK (amount >= 0);

-- Indexes for common lookups
CREATE INDEX IF NOT EXISTS idx_users_username ON users (username);
CREATE INDEX IF NOT EXISTS idx_users_email ON users (email);
CREATE INDEX IF NOT EXISTS idx_user_roles_user ON user_roles (user_id);
CREATE INDEX IF NOT EXISTS idx_user_roles_role ON user_roles (role_id);

CREATE INDEX IF NOT EXISTS idx_projects_code ON projects (project_code);
CREATE INDEX IF NOT EXISTS idx_projects_status ON projects (status);
CREATE INDEX IF NOT EXISTS idx_projects_location ON projects (location_id);

CREATE INDEX IF NOT EXISTS idx_sites_project ON sites (project_id);
CREATE INDEX IF NOT EXISTS idx_sites_location ON sites (location_id);

CREATE INDEX IF NOT EXISTS idx_tenders_project ON tenders (project_id);
CREATE INDEX IF NOT EXISTS idx_tenders_status ON tenders (status);

CREATE INDEX IF NOT EXISTS idx_contracts_tender ON contracts (tender_id);
CREATE INDEX IF NOT EXISTS idx_contracts_contractor ON contracts (contractor_id);
CREATE INDEX IF NOT EXISTS idx_contracts_status ON contracts (status);

CREATE INDEX IF NOT EXISTS idx_milestones_project ON milestones (project_id);
CREATE INDEX IF NOT EXISTS idx_milestone_updates_milestone ON milestone_updates (milestone_id);
CREATE INDEX IF NOT EXISTS idx_milestone_updates_status ON milestone_updates (status);

CREATE INDEX IF NOT EXISTS idx_inspections_project ON inspections (project_id);
CREATE INDEX IF NOT EXISTS idx_inspections_site ON inspections (site_id);

CREATE INDEX IF NOT EXISTS idx_handovers_project ON handovers (project_id);

CREATE INDEX IF NOT EXISTS idx_funds_project ON funds (project_id);

CREATE INDEX IF NOT EXISTS idx_payments_project ON payments (project_id);
CREATE INDEX IF NOT EXISTS idx_payments_contract ON payments (contract_id);
CREATE INDEX IF NOT EXISTS idx_payments_milestone ON payments (milestone_id);

CREATE INDEX IF NOT EXISTS idx_documents_project ON documents (project_id);
CREATE INDEX IF NOT EXISTS idx_notifications_user ON notifications (user_id);

-- Foreign keys for document entity_id are logical, not enforced (entity varies).
-- Additional temporal indexes for reporting
CREATE INDEX IF NOT EXISTS idx_audit_log_created_at ON audit_log (created_at);
CREATE INDEX IF NOT EXISTS idx_payments_date ON payments (payment_date);
CREATE INDEX IF NOT EXISTS idx_funds_release_date ON funds (release_date);
CREATE INDEX IF NOT EXISTS idx_milestone_updates_date ON milestone_updates (update_date);
