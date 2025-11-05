-- 03_seed.sql
-- Seed roles, admin user, sample locations, projects, and basic demo data

-- Seed Roles
INSERT INTO roles (name, description) VALUES
    ('ADMIN', 'System administrator with full access'),
    ('DEO', 'Data Entry Operator'),
    ('ENGINEER', 'Project Engineer'),
    ('AUDITOR', 'Auditor for compliance and QA'),
    ('VIEWER', 'Read-only access')
ON CONFLICT (name) DO NOTHING;

-- Create admin user with hashed password (bcrypt $2b$ cost 10)
-- Default password: Admin@123 (change in production!)
WITH ins AS (
    INSERT INTO users (username, email, password_hash, full_name, phone, status)
    VALUES (
        'admin',
        'admin@uptourism.local',
        '$2b$10$0s7pJc.7uYv4yS9c9wC1MeoJmXkXh3w0GzJdNf4b0jBqLq9Wzqgwy',
        'System Administrator',
        '+910000000000',
        'ACTIVE'
    )
    ON CONFLICT (username) DO NOTHING
    RETURNING id
)
-- Assign ADMIN role
INSERT INTO user_roles (user_id, role_id, assigned_at)
SELECT 
    COALESCE((SELECT id FROM ins), (SELECT id FROM users WHERE username = 'admin')),
    (SELECT id FROM roles WHERE name = 'ADMIN'),
    NOW()
WHERE (SELECT COUNT(*) FROM user_roles ur 
       JOIN users u ON u.id = ur.user_id 
       JOIN roles r ON r.id = ur.role_id 
       WHERE u.username = 'admin' AND r.name = 'ADMIN') = 0;

-- Seed basic location hierarchy
INSERT INTO locations (name, parent_id, level, code)
VALUES ('Uttar Pradesh', NULL, 'STATE', 'UP')
ON CONFLICT DO NOTHING;

INSERT INTO locations (name, parent_id, level, code)
SELECT 'Lucknow', (SELECT id FROM locations WHERE name = 'Uttar Pradesh' AND level='STATE'), 'DISTRICT', 'LKO'
WHERE NOT EXISTS (SELECT 1 FROM locations WHERE name='Lucknow' AND level='DISTRICT');

INSERT INTO locations (name, parent_id, level, code)
SELECT 'Varanasi', (SELECT id FROM locations WHERE name = 'Uttar Pradesh' AND level='STATE'), 'DISTRICT', 'VNS'
WHERE NOT EXISTS (SELECT 1 FROM locations WHERE name='Varanasi' AND level='DISTRICT');

-- Seed sample project
INSERT INTO projects (project_code, name, description, department, start_date, end_date, status, estimated_cost, approved_budget, location_id, latitude, longitude, created_by)
SELECT 
    'PRJ-001', 
    'Tourist Information Center - Lucknow', 
    'Setup of modern Tourist Information Center with amenities.',
    'UPSTDC',
    CURRENT_DATE - INTERVAL '60 days',
    CURRENT_DATE + INTERVAL '120 days',
    'ONGOING',
    25000000, 22000000,
    (SELECT id FROM locations WHERE name='Lucknow' AND level='DISTRICT'),
    26.8467, 80.9462,
    (SELECT id FROM users WHERE username='admin')
WHERE NOT EXISTS (SELECT 1 FROM projects WHERE project_code='PRJ-001');

INSERT INTO sites (project_id, name, description, address, location_id, latitude, longitude)
SELECT 
    p.id, 'Primary Site', 'Main TIC building', 'Hazratganj, Lucknow',
    (SELECT id FROM locations WHERE name='Lucknow' AND level='DISTRICT'),
    26.852, 80.949
FROM projects p WHERE p.project_code='PRJ-001'
ON CONFLICT DO NOTHING;

-- Seed tender and contractor and contract
INSERT INTO tenders (project_id, tender_no, title, description, publish_date, close_date, status)
SELECT p.id, 'TN-001', 'Construction Tender', 'Construction and interiors', CURRENT_DATE - INTERVAL '45 days', CURRENT_DATE - INTERVAL '15 days', 'AWARDED'
FROM projects p WHERE p.project_code='PRJ-001'
ON CONFLICT (tender_no) DO NOTHING;

INSERT INTO contractors (name, registration_no, contact_person, email, phone, address, rating)
VALUES ('ABC Constructions Pvt Ltd', 'REG-ABC-001', 'Mr. Sharma', 'contact@abcconstructions.com', '+911234567890', 'Gomti Nagar, Lucknow', 4.5)
ON CONFLICT (registration_no) DO NOTHING;

INSERT INTO contracts (tender_id, contractor_id, contract_no, title, start_date, end_date, value, status)
SELECT 
    (SELECT id FROM tenders WHERE tender_no='TN-001'),
    (SELECT id FROM contractors WHERE registration_no='REG-ABC-001'),
    'CN-001', 'Construction Contract', CURRENT_DATE - INTERVAL '30 days', CURRENT_DATE + INTERVAL '150 days', 18000000, 'ACTIVE'
WHERE NOT EXISTS (SELECT 1 FROM contracts WHERE contract_no='CN-001');

-- Seed milestones
INSERT INTO milestones (project_id, name, description, planned_start, planned_end, amount, sequence_no, status)
SELECT p.id, 'Foundation', 'Excavation and foundation', CURRENT_DATE - INTERVAL '30 days', CURRENT_DATE - INTERVAL '10 days', 5000000, 1, 'COMPLETED'
FROM projects p WHERE p.project_code='PRJ-001'
ON CONFLICT DO NOTHING;

INSERT INTO milestones (project_id, name, description, planned_start, planned_end, amount, sequence_no, status)
SELECT p.id, 'Superstructure', 'Structural works', CURRENT_DATE - INTERVAL '10 days', CURRENT_DATE + INTERVAL '30 days', 7000000, 2, 'IN_PROGRESS'
FROM projects p WHERE p.project_code='PRJ-001'
ON CONFLICT DO NOTHING;

-- Seed milestone updates
INSERT INTO milestone_updates (milestone_id, update_date, status, progress_percent, remarks, latitude, longitude, photo_url, created_by)
SELECT m.id, CURRENT_DATE - INTERVAL '8 days', 'IN_PROGRESS', 50.00, 'Work at 50%', 26.8521, 80.9492, '/uploads/m1_1.jpg', (SELECT id FROM users WHERE username='admin')
FROM milestones m JOIN projects p ON p.id = m.project_id WHERE p.project_code='PRJ-001' AND m.sequence_no=2
ON CONFLICT DO NOTHING;

INSERT INTO milestone_updates (milestone_id, update_date, status, progress_percent, remarks, latitude, longitude, photo_url, created_by)
SELECT m.id, CURRENT_DATE - INTERVAL '2 days', 'IN_PROGRESS', 65.00, 'Work at 65%', 26.8522, 80.9493, '/uploads/m1_2.jpg', (SELECT id FROM users WHERE username='admin')
FROM milestones m JOIN projects p ON p.id = m.project_id WHERE p.project_code='PRJ-001' AND m.sequence_no=2
ON CONFLICT DO NOTHING;

-- Seed inspections
INSERT INTO inspections (project_id, site_id, inspection_date, inspector_id, outcome, remarks)
SELECT p.id, s.id, CURRENT_DATE - INTERVAL '3 days', (SELECT id FROM users WHERE username='admin'), 'PASS', 'Quality acceptable'
FROM projects p 
JOIN sites s ON s.project_id = p.id
WHERE p.project_code='PRJ-001'
ON CONFLICT DO NOTHING;

-- Seed handover (pending)
INSERT INTO handovers (project_id, handover_date, status, remarks, document_url)
SELECT p.id, NULL, 'PENDING', 'Pending final completion', NULL
FROM projects p WHERE p.project_code='PRJ-001'
ON CONFLICT DO NOTHING;

-- Seed funds and payments
INSERT INTO funds (project_id, fund_source, sanctioned_amount, release_date, remarks)
SELECT p.id, 'State Budget', 22000000, CURRENT_DATE - INTERVAL '50 days', 'Initial sanction'
FROM projects p WHERE p.project_code='PRJ-001'
ON CONFLICT DO NOTHING;

INSERT INTO payments (project_id, contract_id, milestone_id, amount, payment_date, status, reference_no)
SELECT p.id, c.id, (SELECT id FROM milestones WHERE project_id=p.id AND sequence_no=1), 4500000, CURRENT_DATE - INTERVAL '5 days', 'PAID', 'PAY-001'
FROM projects p 
JOIN contracts c ON c.tender_id = (SELECT id FROM tenders WHERE project_id=p.id)
WHERE p.project_code='PRJ-001'
ON CONFLICT DO NOTHING;

-- Seed documents
INSERT INTO documents (project_id, entity_type, entity_id, file_name, file_url, uploaded_by, description)
SELECT p.id, 'PROJECT', p.id, 'project_brief.pdf', '/uploads/project_brief.pdf', (SELECT id FROM users WHERE username='admin'), 'Project brief document'
FROM projects p WHERE p.project_code='PRJ-001'
ON CONFLICT DO NOTHING;

-- Seed notifications
INSERT INTO notifications (user_id, type, title, message, is_read)
SELECT (SELECT id FROM users WHERE username='admin'), 'INFO', 'Setup Complete', 'Database initialized with seed data.', FALSE
WHERE NOT EXISTS (SELECT 1 FROM notifications WHERE title='Setup Complete');
