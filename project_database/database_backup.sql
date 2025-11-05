--
-- PostgreSQL database dump
--

\restrict 2BmqKLP4qaA2e7qywEJrceMAhUxqZobOPtavxRPhmDvMVgvfTWhdc6WNXaVLudg

-- Dumped from database version 16.10 (Ubuntu 16.10-0ubuntu0.24.04.1)
-- Dumped by pg_dump version 16.10 (Ubuntu 16.10-0ubuntu0.24.04.1)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

DROP DATABASE IF EXISTS myapp;
--
-- Name: myapp; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE myapp WITH TEMPLATE = template0 ENCODING = 'UTF8' LOCALE_PROVIDER = libc LOCALE = 'en_US.UTF-8';


ALTER DATABASE myapp OWNER TO postgres;

\unrestrict 2BmqKLP4qaA2e7qywEJrceMAhUxqZobOPtavxRPhmDvMVgvfTWhdc6WNXaVLudg
\connect myapp
\restrict 2BmqKLP4qaA2e7qywEJrceMAhUxqZobOPtavxRPhmDvMVgvfTWhdc6WNXaVLudg

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

--
-- Name: pgcrypto; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS pgcrypto WITH SCHEMA public;


--
-- Name: EXTENSION pgcrypto; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION pgcrypto IS 'cryptographic functions';


--
-- Name: uuid-ossp; Type: EXTENSION; Schema: -; Owner: -
--

CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;


--
-- Name: EXTENSION "uuid-ossp"; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION "uuid-ossp" IS 'generate universally unique identifiers (UUIDs)';


--
-- Name: contract_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.contract_status AS ENUM (
    'ACTIVE',
    'COMPLETED',
    'TERMINATED',
    'SUSPENDED'
);


ALTER TYPE public.contract_status OWNER TO postgres;

--
-- Name: document_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.document_type AS ENUM (
    'TENDER',
    'CONTRACT',
    'MILESTONE',
    'INSPECTION',
    'HANDOVER',
    'PAYMENT',
    'PROJECT',
    'OTHER'
);


ALTER TYPE public.document_type OWNER TO postgres;

--
-- Name: handover_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.handover_status AS ENUM (
    'PENDING',
    'PARTIAL',
    'COMPLETED'
);


ALTER TYPE public.handover_status OWNER TO postgres;

--
-- Name: inspection_outcome; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.inspection_outcome AS ENUM (
    'PASS',
    'FAIL',
    'CONDITIONAL'
);


ALTER TYPE public.inspection_outcome OWNER TO postgres;

--
-- Name: milestone_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.milestone_status AS ENUM (
    'NOT_STARTED',
    'IN_PROGRESS',
    'COMPLETED',
    'DELAYED'
);


ALTER TYPE public.milestone_status OWNER TO postgres;

--
-- Name: notification_type; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.notification_type AS ENUM (
    'INFO',
    'WARNING',
    'ALERT',
    'TASK'
);


ALTER TYPE public.notification_type OWNER TO postgres;

--
-- Name: payment_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.payment_status AS ENUM (
    'PENDING',
    'PROCESSING',
    'PAID',
    'FAILED',
    'REVERSED'
);


ALTER TYPE public.payment_status OWNER TO postgres;

--
-- Name: project_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.project_status AS ENUM (
    'PLANNED',
    'ONGOING',
    'ON_HOLD',
    'COMPLETED',
    'CANCELLED'
);


ALTER TYPE public.project_status OWNER TO postgres;

--
-- Name: tender_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.tender_status AS ENUM (
    'DRAFT',
    'PUBLISHED',
    'CLOSED',
    'AWARDED',
    'CANCELLED'
);


ALTER TYPE public.tender_status OWNER TO postgres;

--
-- Name: user_status; Type: TYPE; Schema: public; Owner: postgres
--

CREATE TYPE public.user_status AS ENUM (
    'ACTIVE',
    'INACTIVE',
    'SUSPENDED'
);


ALTER TYPE public.user_status OWNER TO postgres;

--
-- Name: set_updated_at(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION public.set_updated_at() RETURNS trigger
    LANGUAGE plpgsql
    AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$;


ALTER FUNCTION public.set_updated_at() OWNER TO postgres;

SET default_tablespace = '';

SET default_table_access_method = heap;

--
-- Name: audit_log; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.audit_log (
    id bigint NOT NULL,
    user_id integer,
    action character varying(100) NOT NULL,
    entity character varying(100) NOT NULL,
    entity_id character varying(100),
    description text,
    ip_address character varying(64),
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.audit_log OWNER TO postgres;

--
-- Name: audit_log_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.audit_log_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.audit_log_id_seq OWNER TO postgres;

--
-- Name: audit_log_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.audit_log_id_seq OWNED BY public.audit_log.id;


--
-- Name: contractors; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contractors (
    id integer NOT NULL,
    name character varying(200) NOT NULL,
    registration_no character varying(100),
    contact_person character varying(150),
    email character varying(150),
    phone character varying(50),
    address text,
    rating numeric(3,2) DEFAULT 0.0,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.contractors OWNER TO postgres;

--
-- Name: contractors_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.contractors_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.contractors_id_seq OWNER TO postgres;

--
-- Name: contractors_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.contractors_id_seq OWNED BY public.contractors.id;


--
-- Name: contracts; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.contracts (
    id integer NOT NULL,
    tender_id integer NOT NULL,
    contractor_id integer NOT NULL,
    contract_no character varying(100) NOT NULL,
    title character varying(200) NOT NULL,
    start_date date,
    end_date date,
    value numeric(14,2) DEFAULT 0 NOT NULL,
    status public.contract_status DEFAULT 'ACTIVE'::public.contract_status NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.contracts OWNER TO postgres;

--
-- Name: contracts_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.contracts_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.contracts_id_seq OWNER TO postgres;

--
-- Name: contracts_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.contracts_id_seq OWNED BY public.contracts.id;


--
-- Name: documents; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.documents (
    id integer NOT NULL,
    project_id integer,
    entity_type public.document_type NOT NULL,
    entity_id integer,
    file_name character varying(255) NOT NULL,
    file_url text NOT NULL,
    uploaded_by integer,
    uploaded_at timestamp with time zone DEFAULT now(),
    description text
);


ALTER TABLE public.documents OWNER TO postgres;

--
-- Name: documents_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.documents_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.documents_id_seq OWNER TO postgres;

--
-- Name: documents_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.documents_id_seq OWNED BY public.documents.id;


--
-- Name: funds; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.funds (
    id integer NOT NULL,
    project_id integer NOT NULL,
    fund_source character varying(150) NOT NULL,
    sanctioned_amount numeric(14,2) DEFAULT 0 NOT NULL,
    release_date date,
    remarks text,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT chk_funds_sanctioned_nonneg CHECK ((sanctioned_amount >= (0)::numeric))
);


ALTER TABLE public.funds OWNER TO postgres;

--
-- Name: funds_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.funds_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.funds_id_seq OWNER TO postgres;

--
-- Name: funds_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.funds_id_seq OWNED BY public.funds.id;


--
-- Name: handovers; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.handovers (
    id integer NOT NULL,
    project_id integer NOT NULL,
    handover_date date,
    status public.handover_status DEFAULT 'PENDING'::public.handover_status NOT NULL,
    remarks text,
    document_url text,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.handovers OWNER TO postgres;

--
-- Name: handovers_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.handovers_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.handovers_id_seq OWNER TO postgres;

--
-- Name: handovers_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.handovers_id_seq OWNED BY public.handovers.id;


--
-- Name: inspections; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.inspections (
    id integer NOT NULL,
    project_id integer NOT NULL,
    site_id integer,
    inspection_date date DEFAULT CURRENT_DATE NOT NULL,
    inspector_id integer,
    outcome public.inspection_outcome NOT NULL,
    remarks text,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.inspections OWNER TO postgres;

--
-- Name: inspections_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.inspections_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.inspections_id_seq OWNER TO postgres;

--
-- Name: inspections_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.inspections_id_seq OWNED BY public.inspections.id;


--
-- Name: locations; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.locations (
    id integer NOT NULL,
    name character varying(150) NOT NULL,
    parent_id integer,
    level character varying(50) NOT NULL,
    code character varying(50),
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.locations OWNER TO postgres;

--
-- Name: locations_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.locations_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.locations_id_seq OWNER TO postgres;

--
-- Name: locations_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.locations_id_seq OWNED BY public.locations.id;


--
-- Name: milestone_updates; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.milestone_updates (
    id integer NOT NULL,
    milestone_id integer NOT NULL,
    update_date date DEFAULT CURRENT_DATE NOT NULL,
    status public.milestone_status NOT NULL,
    progress_percent numeric(5,2) DEFAULT 0,
    remarks text,
    latitude numeric(10,6),
    longitude numeric(10,6),
    photo_url text,
    created_by integer,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.milestone_updates OWNER TO postgres;

--
-- Name: milestone_updates_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.milestone_updates_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.milestone_updates_id_seq OWNER TO postgres;

--
-- Name: milestone_updates_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.milestone_updates_id_seq OWNED BY public.milestone_updates.id;


--
-- Name: milestones; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.milestones (
    id integer NOT NULL,
    project_id integer NOT NULL,
    name character varying(200) NOT NULL,
    description text,
    planned_start date,
    planned_end date,
    amount numeric(14,2) DEFAULT 0,
    sequence_no integer,
    status public.milestone_status DEFAULT 'NOT_STARTED'::public.milestone_status NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT chk_milestones_amount_nonneg CHECK ((amount >= (0)::numeric))
);


ALTER TABLE public.milestones OWNER TO postgres;

--
-- Name: milestones_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.milestones_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.milestones_id_seq OWNER TO postgres;

--
-- Name: milestones_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.milestones_id_seq OWNED BY public.milestones.id;


--
-- Name: notifications; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.notifications (
    id integer NOT NULL,
    user_id integer,
    type public.notification_type DEFAULT 'INFO'::public.notification_type NOT NULL,
    title character varying(200) NOT NULL,
    message text NOT NULL,
    is_read boolean DEFAULT false NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.notifications OWNER TO postgres;

--
-- Name: notifications_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.notifications_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.notifications_id_seq OWNER TO postgres;

--
-- Name: notifications_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.notifications_id_seq OWNED BY public.notifications.id;


--
-- Name: payments; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.payments (
    id integer NOT NULL,
    project_id integer NOT NULL,
    contract_id integer,
    milestone_id integer,
    amount numeric(14,2) NOT NULL,
    payment_date date DEFAULT CURRENT_DATE NOT NULL,
    status public.payment_status DEFAULT 'PENDING'::public.payment_status NOT NULL,
    reference_no character varying(100),
    created_at timestamp with time zone DEFAULT now(),
    CONSTRAINT chk_payments_amount_positive CHECK ((amount >= (0)::numeric))
);


ALTER TABLE public.payments OWNER TO postgres;

--
-- Name: payments_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.payments_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.payments_id_seq OWNER TO postgres;

--
-- Name: payments_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.payments_id_seq OWNED BY public.payments.id;


--
-- Name: projects; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.projects (
    id integer NOT NULL,
    project_code character varying(50) NOT NULL,
    name character varying(200) NOT NULL,
    description text,
    department character varying(150),
    start_date date,
    end_date date,
    status public.project_status DEFAULT 'PLANNED'::public.project_status NOT NULL,
    estimated_cost numeric(14,2) DEFAULT 0,
    approved_budget numeric(14,2) DEFAULT 0,
    location_id integer,
    latitude numeric(10,6),
    longitude numeric(10,6),
    created_by integer,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.projects OWNER TO postgres;

--
-- Name: projects_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.projects_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.projects_id_seq OWNER TO postgres;

--
-- Name: projects_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.projects_id_seq OWNED BY public.projects.id;


--
-- Name: refresh_tokens; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.refresh_tokens (
    id uuid DEFAULT public.uuid_generate_v4() NOT NULL,
    user_id integer NOT NULL,
    token character varying(255) NOT NULL,
    expires_at timestamp with time zone NOT NULL,
    created_at timestamp with time zone DEFAULT now(),
    revoked boolean DEFAULT false NOT NULL,
    revoked_at timestamp with time zone
);


ALTER TABLE public.refresh_tokens OWNER TO postgres;

--
-- Name: roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.roles (
    id integer NOT NULL,
    name character varying(50) NOT NULL,
    description text,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.roles OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.roles_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.roles_id_seq OWNER TO postgres;

--
-- Name: roles_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.roles_id_seq OWNED BY public.roles.id;


--
-- Name: sites; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.sites (
    id integer NOT NULL,
    project_id integer NOT NULL,
    name character varying(200) NOT NULL,
    description text,
    address text,
    location_id integer,
    latitude numeric(10,6),
    longitude numeric(10,6),
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.sites OWNER TO postgres;

--
-- Name: sites_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.sites_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.sites_id_seq OWNER TO postgres;

--
-- Name: sites_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.sites_id_seq OWNED BY public.sites.id;


--
-- Name: tenders; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.tenders (
    id integer NOT NULL,
    project_id integer NOT NULL,
    tender_no character varying(100) NOT NULL,
    title character varying(200) NOT NULL,
    description text,
    publish_date date,
    close_date date,
    status public.tender_status DEFAULT 'DRAFT'::public.tender_status NOT NULL,
    created_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.tenders OWNER TO postgres;

--
-- Name: tenders_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.tenders_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.tenders_id_seq OWNER TO postgres;

--
-- Name: tenders_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.tenders_id_seq OWNED BY public.tenders.id;


--
-- Name: user_roles; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.user_roles (
    user_id integer NOT NULL,
    role_id integer NOT NULL,
    assigned_at timestamp with time zone DEFAULT now(),
    assigned_by integer
);


ALTER TABLE public.user_roles OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.users (
    id integer NOT NULL,
    username character varying(80) NOT NULL,
    email character varying(180) NOT NULL,
    password_hash character varying(255) NOT NULL,
    full_name character varying(180),
    phone character varying(30),
    status public.user_status DEFAULT 'ACTIVE'::public.user_status NOT NULL,
    last_login_at timestamp with time zone,
    created_at timestamp with time zone DEFAULT now(),
    updated_at timestamp with time zone DEFAULT now()
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.users_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.users_id_seq OWNER TO postgres;

--
-- Name: users_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.users_id_seq OWNED BY public.users.id;


--
-- Name: v_contractor_performance; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_contractor_performance AS
 SELECT c.id AS contractor_id,
    c.name AS contractor_name,
    c.rating,
    count(DISTINCT ct.id) AS contracts_count,
    count(DISTINCT p.id) AS projects_count,
    COALESCE(sum(ct.value), (0)::numeric) AS total_contract_value,
    COALESCE(sum(pay.amount), (0)::numeric) AS total_paid_amount,
    round(avg(
        CASE
            WHEN (m.status = 'COMPLETED'::public.milestone_status) THEN (100)::numeric
            ELSE COALESCE(mu.progress_percent, (0)::numeric)
        END), 2) AS avg_progress_percent
   FROM ((((((public.contractors c
     LEFT JOIN public.contracts ct ON ((ct.contractor_id = c.id)))
     LEFT JOIN public.tenders t ON ((t.id = ct.tender_id)))
     LEFT JOIN public.projects p ON ((p.id = t.project_id)))
     LEFT JOIN public.milestones m ON ((m.project_id = p.id)))
     LEFT JOIN LATERAL ( SELECT mu1.progress_percent
           FROM public.milestone_updates mu1
          WHERE (mu1.milestone_id = m.id)
          ORDER BY mu1.update_date DESC, mu1.id DESC
         LIMIT 1) mu ON (true))
     LEFT JOIN public.payments pay ON (((pay.contract_id = ct.id) AND (pay.status = ANY (ARRAY['PAID'::public.payment_status, 'PROCESSING'::public.payment_status])))))
  GROUP BY c.id, c.name, c.rating;


ALTER VIEW public.v_contractor_performance OWNER TO postgres;

--
-- Name: v_fund_utilization; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_fund_utilization AS
 SELECT p.id AS project_id,
    p.project_code,
    p.name AS project_name,
    COALESCE(funds.total_funds, (0)::numeric) AS total_funds,
    COALESCE(pay.total_paid, (0)::numeric) AS total_paid,
        CASE
            WHEN (COALESCE(funds.total_funds, (0)::numeric) = (0)::numeric) THEN (0)::numeric
            ELSE round(((100.0 * COALESCE(pay.total_paid, (0)::numeric)) / funds.total_funds), 2)
        END AS utilization_percent
   FROM ((public.projects p
     LEFT JOIN ( SELECT funds_1.project_id,
            sum(funds_1.sanctioned_amount) AS total_funds
           FROM public.funds funds_1
          GROUP BY funds_1.project_id) funds ON ((funds.project_id = p.id)))
     LEFT JOIN ( SELECT payments.project_id,
            sum(payments.amount) AS total_paid
           FROM public.payments
          WHERE (payments.status = 'PAID'::public.payment_status)
          GROUP BY payments.project_id) pay ON ((pay.project_id = p.id)));


ALTER VIEW public.v_fund_utilization OWNER TO postgres;

--
-- Name: v_geo_progress; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_geo_progress AS
 SELECT p.id AS project_id,
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
   FROM ((public.projects p
     LEFT JOIN public.sites s ON ((s.project_id = p.id)))
     LEFT JOIN LATERAL ( SELECT mu1.id,
            mu1.milestone_id,
            mu1.update_date,
            mu1.status,
            mu1.progress_percent,
            mu1.remarks,
            mu1.latitude,
            mu1.longitude,
            mu1.photo_url,
            mu1.created_by,
            mu1.created_at
           FROM (public.milestones m1
             JOIN public.milestone_updates mu1 ON ((mu1.milestone_id = m1.id)))
          WHERE (m1.project_id = p.id)
          ORDER BY mu1.update_date DESC, mu1.id DESC
         LIMIT 1) mu ON (true));


ALTER VIEW public.v_geo_progress OWNER TO postgres;

--
-- Name: v_project_overview; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW public.v_project_overview AS
 SELECT p.id AS project_id,
    p.project_code,
    p.name AS project_name,
    p.status,
    p.estimated_cost,
    p.approved_budget,
    COALESCE(f.total_funds, (0)::numeric) AS total_funds_sanctioned,
    COALESCE(pay.total_payments, (0)::numeric) AS total_payments_made,
    COALESCE(mstat.milestones_total, (0)::bigint) AS milestones_total,
    COALESCE(mstat.milestones_completed, (0)::bigint) AS milestones_completed,
    round(COALESCE(mstat.progress_avg, (0)::numeric), 2) AS avg_progress_percent,
    p.start_date,
    p.end_date,
    p.location_id
   FROM (((public.projects p
     LEFT JOIN ( SELECT funds.project_id,
            sum(funds.sanctioned_amount) AS total_funds
           FROM public.funds
          GROUP BY funds.project_id) f ON ((f.project_id = p.id)))
     LEFT JOIN ( SELECT payments.project_id,
            sum(payments.amount) AS total_payments
           FROM public.payments
          WHERE (payments.status = ANY (ARRAY['PAID'::public.payment_status, 'PROCESSING'::public.payment_status]))
          GROUP BY payments.project_id) pay ON ((pay.project_id = p.id)))
     LEFT JOIN ( SELECT m.project_id,
            count(*) AS milestones_total,
            sum(
                CASE
                    WHEN (m.status = 'COMPLETED'::public.milestone_status) THEN 1
                    ELSE 0
                END) AS milestones_completed,
            avg(COALESCE(mu.progress_percent, (
                CASE
                    WHEN (m.status = 'COMPLETED'::public.milestone_status) THEN 100
                    ELSE 0
                END)::numeric)) AS progress_avg
           FROM (public.milestones m
             LEFT JOIN LATERAL ( SELECT mu1.progress_percent
                   FROM public.milestone_updates mu1
                  WHERE (mu1.milestone_id = m.id)
                  ORDER BY mu1.update_date DESC, mu1.id DESC
                 LIMIT 1) mu ON (true))
          GROUP BY m.project_id) mstat ON ((mstat.project_id = p.id)));


ALTER VIEW public.v_project_overview OWNER TO postgres;

--
-- Name: audit_log id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_log ALTER COLUMN id SET DEFAULT nextval('public.audit_log_id_seq'::regclass);


--
-- Name: contractors id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contractors ALTER COLUMN id SET DEFAULT nextval('public.contractors_id_seq'::regclass);


--
-- Name: contracts id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contracts ALTER COLUMN id SET DEFAULT nextval('public.contracts_id_seq'::regclass);


--
-- Name: documents id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documents ALTER COLUMN id SET DEFAULT nextval('public.documents_id_seq'::regclass);


--
-- Name: funds id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.funds ALTER COLUMN id SET DEFAULT nextval('public.funds_id_seq'::regclass);


--
-- Name: handovers id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.handovers ALTER COLUMN id SET DEFAULT nextval('public.handovers_id_seq'::regclass);


--
-- Name: inspections id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inspections ALTER COLUMN id SET DEFAULT nextval('public.inspections_id_seq'::regclass);


--
-- Name: locations id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locations ALTER COLUMN id SET DEFAULT nextval('public.locations_id_seq'::regclass);


--
-- Name: milestone_updates id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.milestone_updates ALTER COLUMN id SET DEFAULT nextval('public.milestone_updates_id_seq'::regclass);


--
-- Name: milestones id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.milestones ALTER COLUMN id SET DEFAULT nextval('public.milestones_id_seq'::regclass);


--
-- Name: notifications id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications ALTER COLUMN id SET DEFAULT nextval('public.notifications_id_seq'::regclass);


--
-- Name: payments id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments ALTER COLUMN id SET DEFAULT nextval('public.payments_id_seq'::regclass);


--
-- Name: projects id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects ALTER COLUMN id SET DEFAULT nextval('public.projects_id_seq'::regclass);


--
-- Name: roles id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles ALTER COLUMN id SET DEFAULT nextval('public.roles_id_seq'::regclass);


--
-- Name: sites id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sites ALTER COLUMN id SET DEFAULT nextval('public.sites_id_seq'::regclass);


--
-- Name: tenders id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tenders ALTER COLUMN id SET DEFAULT nextval('public.tenders_id_seq'::regclass);


--
-- Name: users id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users ALTER COLUMN id SET DEFAULT nextval('public.users_id_seq'::regclass);


--
-- Data for Name: audit_log; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.audit_log (id, user_id, action, entity, entity_id, description, ip_address, created_at) FROM stdin;
\.


--
-- Data for Name: contractors; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contractors (id, name, registration_no, contact_person, email, phone, address, rating, created_at) FROM stdin;
1	ABC Constructions Pvt Ltd	REG-ABC-001	Mr. Sharma	contact@abcconstructions.com	+911234567890	Gomti Nagar, Lucknow	4.50	2025-11-05 09:03:21.209791+00
\.


--
-- Data for Name: contracts; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.contracts (id, tender_id, contractor_id, contract_no, title, start_date, end_date, value, status, created_at) FROM stdin;
1	1	1	CN-001	Construction Contract	2025-10-06	2026-04-04	18000000.00	ACTIVE	2025-11-05 09:03:21.211088+00
\.


--
-- Data for Name: documents; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.documents (id, project_id, entity_type, entity_id, file_name, file_url, uploaded_by, uploaded_at, description) FROM stdin;
1	1	PROJECT	1	project_brief.pdf	/uploads/project_brief.pdf	1	2025-11-05 09:03:21.225399+00	Project brief document
2	1	PROJECT	1	project_brief.pdf	/uploads/project_brief.pdf	1	2025-11-05 09:04:15.410257+00	Project brief document
3	1	PROJECT	1	project_brief.pdf	/uploads/project_brief.pdf	1	2025-11-05 09:07:08.240271+00	Project brief document
4	1	PROJECT	1	project_brief.pdf	/uploads/project_brief.pdf	1	2025-11-05 09:11:17.654573+00	Project brief document
5	1	PROJECT	1	project_brief.pdf	/uploads/project_brief.pdf	1	2025-11-05 09:13:04.150156+00	Project brief document
6	1	PROJECT	1	project_brief.pdf	/uploads/project_brief.pdf	1	2025-11-05 09:17:13.869111+00	Project brief document
7	1	PROJECT	1	project_brief.pdf	/uploads/project_brief.pdf	1	2025-11-05 09:18:27.120024+00	Project brief document
\.


--
-- Data for Name: funds; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.funds (id, project_id, fund_source, sanctioned_amount, release_date, remarks, created_at) FROM stdin;
1	1	State Budget	22000000.00	2025-09-16	Initial sanction	2025-11-05 09:03:21.221892+00
2	1	State Budget	22000000.00	2025-09-16	Initial sanction	2025-11-05 09:04:15.408442+00
3	1	State Budget	22000000.00	2025-09-16	Initial sanction	2025-11-05 09:07:08.238504+00
4	1	State Budget	22000000.00	2025-09-16	Initial sanction	2025-11-05 09:11:17.652747+00
5	1	State Budget	22000000.00	2025-09-16	Initial sanction	2025-11-05 09:13:04.148299+00
6	1	State Budget	22000000.00	2025-09-16	Initial sanction	2025-11-05 09:17:13.867361+00
7	1	State Budget	22000000.00	2025-09-16	Initial sanction	2025-11-05 09:18:27.118245+00
\.


--
-- Data for Name: handovers; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.handovers (id, project_id, handover_date, status, remarks, document_url, created_at) FROM stdin;
1	1	\N	PENDING	Pending final completion	\N	2025-11-05 09:03:21.220475+00
2	1	\N	PENDING	Pending final completion	\N	2025-11-05 09:04:15.407139+00
3	1	\N	PENDING	Pending final completion	\N	2025-11-05 09:07:08.237177+00
4	1	\N	PENDING	Pending final completion	\N	2025-11-05 09:11:17.651477+00
5	1	\N	PENDING	Pending final completion	\N	2025-11-05 09:13:04.14705+00
6	1	\N	PENDING	Pending final completion	\N	2025-11-05 09:17:13.866046+00
7	1	\N	PENDING	Pending final completion	\N	2025-11-05 09:18:27.117011+00
\.


--
-- Data for Name: inspections; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.inspections (id, project_id, site_id, inspection_date, inspector_id, outcome, remarks, created_at) FROM stdin;
1	1	1	2025-11-02	1	PASS	Quality acceptable	2025-11-05 09:03:21.218704+00
2	1	1	2025-11-02	1	PASS	Quality acceptable	2025-11-05 09:04:15.405503+00
3	1	2	2025-11-02	1	PASS	Quality acceptable	2025-11-05 09:04:15.405503+00
4	1	1	2025-11-02	1	PASS	Quality acceptable	2025-11-05 09:07:08.235407+00
5	1	2	2025-11-02	1	PASS	Quality acceptable	2025-11-05 09:07:08.235407+00
6	1	3	2025-11-02	1	PASS	Quality acceptable	2025-11-05 09:07:08.235407+00
7	1	1	2025-11-02	1	PASS	Quality acceptable	2025-11-05 09:11:17.649572+00
8	1	2	2025-11-02	1	PASS	Quality acceptable	2025-11-05 09:11:17.649572+00
9	1	3	2025-11-02	1	PASS	Quality acceptable	2025-11-05 09:11:17.649572+00
10	1	4	2025-11-02	1	PASS	Quality acceptable	2025-11-05 09:11:17.649572+00
11	1	1	2025-11-02	1	PASS	Quality acceptable	2025-11-05 09:13:04.145014+00
12	1	2	2025-11-02	1	PASS	Quality acceptable	2025-11-05 09:13:04.145014+00
13	1	3	2025-11-02	1	PASS	Quality acceptable	2025-11-05 09:13:04.145014+00
14	1	4	2025-11-02	1	PASS	Quality acceptable	2025-11-05 09:13:04.145014+00
15	1	5	2025-11-02	1	PASS	Quality acceptable	2025-11-05 09:13:04.145014+00
16	1	1	2025-11-02	1	PASS	Quality acceptable	2025-11-05 09:17:13.863964+00
17	1	2	2025-11-02	1	PASS	Quality acceptable	2025-11-05 09:17:13.863964+00
18	1	3	2025-11-02	1	PASS	Quality acceptable	2025-11-05 09:17:13.863964+00
19	1	4	2025-11-02	1	PASS	Quality acceptable	2025-11-05 09:17:13.863964+00
20	1	5	2025-11-02	1	PASS	Quality acceptable	2025-11-05 09:17:13.863964+00
21	1	6	2025-11-02	1	PASS	Quality acceptable	2025-11-05 09:17:13.863964+00
22	1	1	2025-11-02	1	PASS	Quality acceptable	2025-11-05 09:18:27.114827+00
23	1	2	2025-11-02	1	PASS	Quality acceptable	2025-11-05 09:18:27.114827+00
24	1	3	2025-11-02	1	PASS	Quality acceptable	2025-11-05 09:18:27.114827+00
25	1	4	2025-11-02	1	PASS	Quality acceptable	2025-11-05 09:18:27.114827+00
26	1	5	2025-11-02	1	PASS	Quality acceptable	2025-11-05 09:18:27.114827+00
27	1	6	2025-11-02	1	PASS	Quality acceptable	2025-11-05 09:18:27.114827+00
28	1	7	2025-11-02	1	PASS	Quality acceptable	2025-11-05 09:18:27.114827+00
\.


--
-- Data for Name: locations; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.locations (id, name, parent_id, level, code, created_at) FROM stdin;
1	Uttar Pradesh	\N	STATE	UP	2025-11-05 09:03:21.200928+00
2	Lucknow	1	DISTRICT	LKO	2025-11-05 09:03:21.202139+00
3	Varanasi	1	DISTRICT	VNS	2025-11-05 09:03:21.20343+00
4	Uttar Pradesh	\N	STATE	UP	2025-11-05 09:04:15.393067+00
5	Uttar Pradesh	\N	STATE	UP	2025-11-05 09:07:08.223069+00
6	Uttar Pradesh	\N	STATE	UP	2025-11-05 09:11:17.637119+00
7	Uttar Pradesh	\N	STATE	UP	2025-11-05 09:13:04.132759+00
8	Uttar Pradesh	\N	STATE	UP	2025-11-05 09:17:13.851597+00
9	Uttar Pradesh	\N	STATE	UP	2025-11-05 09:18:27.102364+00
\.


--
-- Data for Name: milestone_updates; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.milestone_updates (id, milestone_id, update_date, status, progress_percent, remarks, latitude, longitude, photo_url, created_by, created_at) FROM stdin;
1	2	2025-10-28	IN_PROGRESS	50.00	Work at 50%	26.852100	80.949200	/uploads/m1_1.jpg	1	2025-11-05 09:03:21.215575+00
2	2	2025-11-03	IN_PROGRESS	65.00	Work at 65%	26.852200	80.949300	/uploads/m1_2.jpg	1	2025-11-05 09:03:21.217379+00
3	2	2025-10-28	IN_PROGRESS	50.00	Work at 50%	26.852100	80.949200	/uploads/m1_1.jpg	1	2025-11-05 09:04:15.402413+00
4	4	2025-10-28	IN_PROGRESS	50.00	Work at 50%	26.852100	80.949200	/uploads/m1_1.jpg	1	2025-11-05 09:04:15.402413+00
5	2	2025-11-03	IN_PROGRESS	65.00	Work at 65%	26.852200	80.949300	/uploads/m1_2.jpg	1	2025-11-05 09:04:15.404123+00
6	4	2025-11-03	IN_PROGRESS	65.00	Work at 65%	26.852200	80.949300	/uploads/m1_2.jpg	1	2025-11-05 09:04:15.404123+00
7	2	2025-10-28	IN_PROGRESS	50.00	Work at 50%	26.852100	80.949200	/uploads/m1_1.jpg	1	2025-11-05 09:07:08.232133+00
8	4	2025-10-28	IN_PROGRESS	50.00	Work at 50%	26.852100	80.949200	/uploads/m1_1.jpg	1	2025-11-05 09:07:08.232133+00
9	6	2025-10-28	IN_PROGRESS	50.00	Work at 50%	26.852100	80.949200	/uploads/m1_1.jpg	1	2025-11-05 09:07:08.232133+00
10	2	2025-11-03	IN_PROGRESS	65.00	Work at 65%	26.852200	80.949300	/uploads/m1_2.jpg	1	2025-11-05 09:07:08.233876+00
11	4	2025-11-03	IN_PROGRESS	65.00	Work at 65%	26.852200	80.949300	/uploads/m1_2.jpg	1	2025-11-05 09:07:08.233876+00
12	6	2025-11-03	IN_PROGRESS	65.00	Work at 65%	26.852200	80.949300	/uploads/m1_2.jpg	1	2025-11-05 09:07:08.233876+00
13	2	2025-10-28	IN_PROGRESS	50.00	Work at 50%	26.852100	80.949200	/uploads/m1_1.jpg	1	2025-11-05 09:11:17.646003+00
14	4	2025-10-28	IN_PROGRESS	50.00	Work at 50%	26.852100	80.949200	/uploads/m1_1.jpg	1	2025-11-05 09:11:17.646003+00
15	6	2025-10-28	IN_PROGRESS	50.00	Work at 50%	26.852100	80.949200	/uploads/m1_1.jpg	1	2025-11-05 09:11:17.646003+00
16	8	2025-10-28	IN_PROGRESS	50.00	Work at 50%	26.852100	80.949200	/uploads/m1_1.jpg	1	2025-11-05 09:11:17.646003+00
17	2	2025-11-03	IN_PROGRESS	65.00	Work at 65%	26.852200	80.949300	/uploads/m1_2.jpg	1	2025-11-05 09:11:17.648169+00
18	4	2025-11-03	IN_PROGRESS	65.00	Work at 65%	26.852200	80.949300	/uploads/m1_2.jpg	1	2025-11-05 09:11:17.648169+00
19	6	2025-11-03	IN_PROGRESS	65.00	Work at 65%	26.852200	80.949300	/uploads/m1_2.jpg	1	2025-11-05 09:11:17.648169+00
20	8	2025-11-03	IN_PROGRESS	65.00	Work at 65%	26.852200	80.949300	/uploads/m1_2.jpg	1	2025-11-05 09:11:17.648169+00
21	2	2025-10-28	IN_PROGRESS	50.00	Work at 50%	26.852100	80.949200	/uploads/m1_1.jpg	1	2025-11-05 09:13:04.141669+00
22	4	2025-10-28	IN_PROGRESS	50.00	Work at 50%	26.852100	80.949200	/uploads/m1_1.jpg	1	2025-11-05 09:13:04.141669+00
23	6	2025-10-28	IN_PROGRESS	50.00	Work at 50%	26.852100	80.949200	/uploads/m1_1.jpg	1	2025-11-05 09:13:04.141669+00
24	8	2025-10-28	IN_PROGRESS	50.00	Work at 50%	26.852100	80.949200	/uploads/m1_1.jpg	1	2025-11-05 09:13:04.141669+00
25	10	2025-10-28	IN_PROGRESS	50.00	Work at 50%	26.852100	80.949200	/uploads/m1_1.jpg	1	2025-11-05 09:13:04.141669+00
26	2	2025-11-03	IN_PROGRESS	65.00	Work at 65%	26.852200	80.949300	/uploads/m1_2.jpg	1	2025-11-05 09:13:04.143665+00
27	4	2025-11-03	IN_PROGRESS	65.00	Work at 65%	26.852200	80.949300	/uploads/m1_2.jpg	1	2025-11-05 09:13:04.143665+00
28	6	2025-11-03	IN_PROGRESS	65.00	Work at 65%	26.852200	80.949300	/uploads/m1_2.jpg	1	2025-11-05 09:13:04.143665+00
29	8	2025-11-03	IN_PROGRESS	65.00	Work at 65%	26.852200	80.949300	/uploads/m1_2.jpg	1	2025-11-05 09:13:04.143665+00
30	10	2025-11-03	IN_PROGRESS	65.00	Work at 65%	26.852200	80.949300	/uploads/m1_2.jpg	1	2025-11-05 09:13:04.143665+00
43	2	2025-10-28	IN_PROGRESS	50.00	Work at 50%	26.852100	80.949200	/uploads/m1_1.jpg	1	2025-11-05 09:18:27.111483+00
44	4	2025-10-28	IN_PROGRESS	50.00	Work at 50%	26.852100	80.949200	/uploads/m1_1.jpg	1	2025-11-05 09:18:27.111483+00
45	6	2025-10-28	IN_PROGRESS	50.00	Work at 50%	26.852100	80.949200	/uploads/m1_1.jpg	1	2025-11-05 09:18:27.111483+00
46	8	2025-10-28	IN_PROGRESS	50.00	Work at 50%	26.852100	80.949200	/uploads/m1_1.jpg	1	2025-11-05 09:18:27.111483+00
47	10	2025-10-28	IN_PROGRESS	50.00	Work at 50%	26.852100	80.949200	/uploads/m1_1.jpg	1	2025-11-05 09:18:27.111483+00
48	12	2025-10-28	IN_PROGRESS	50.00	Work at 50%	26.852100	80.949200	/uploads/m1_1.jpg	1	2025-11-05 09:18:27.111483+00
49	14	2025-10-28	IN_PROGRESS	50.00	Work at 50%	26.852100	80.949200	/uploads/m1_1.jpg	1	2025-11-05 09:18:27.111483+00
50	2	2025-11-03	IN_PROGRESS	65.00	Work at 65%	26.852200	80.949300	/uploads/m1_2.jpg	1	2025-11-05 09:18:27.11352+00
51	4	2025-11-03	IN_PROGRESS	65.00	Work at 65%	26.852200	80.949300	/uploads/m1_2.jpg	1	2025-11-05 09:18:27.11352+00
52	6	2025-11-03	IN_PROGRESS	65.00	Work at 65%	26.852200	80.949300	/uploads/m1_2.jpg	1	2025-11-05 09:18:27.11352+00
53	8	2025-11-03	IN_PROGRESS	65.00	Work at 65%	26.852200	80.949300	/uploads/m1_2.jpg	1	2025-11-05 09:18:27.11352+00
54	10	2025-11-03	IN_PROGRESS	65.00	Work at 65%	26.852200	80.949300	/uploads/m1_2.jpg	1	2025-11-05 09:18:27.11352+00
55	12	2025-11-03	IN_PROGRESS	65.00	Work at 65%	26.852200	80.949300	/uploads/m1_2.jpg	1	2025-11-05 09:18:27.11352+00
56	14	2025-11-03	IN_PROGRESS	65.00	Work at 65%	26.852200	80.949300	/uploads/m1_2.jpg	1	2025-11-05 09:18:27.11352+00
31	2	2025-10-28	IN_PROGRESS	50.00	Work at 50%	26.852100	80.949200	/uploads/m1_1.jpg	1	2025-11-05 09:17:13.860559+00
32	4	2025-10-28	IN_PROGRESS	50.00	Work at 50%	26.852100	80.949200	/uploads/m1_1.jpg	1	2025-11-05 09:17:13.860559+00
33	6	2025-10-28	IN_PROGRESS	50.00	Work at 50%	26.852100	80.949200	/uploads/m1_1.jpg	1	2025-11-05 09:17:13.860559+00
34	8	2025-10-28	IN_PROGRESS	50.00	Work at 50%	26.852100	80.949200	/uploads/m1_1.jpg	1	2025-11-05 09:17:13.860559+00
35	10	2025-10-28	IN_PROGRESS	50.00	Work at 50%	26.852100	80.949200	/uploads/m1_1.jpg	1	2025-11-05 09:17:13.860559+00
36	12	2025-10-28	IN_PROGRESS	50.00	Work at 50%	26.852100	80.949200	/uploads/m1_1.jpg	1	2025-11-05 09:17:13.860559+00
37	2	2025-11-03	IN_PROGRESS	65.00	Work at 65%	26.852200	80.949300	/uploads/m1_2.jpg	1	2025-11-05 09:17:13.862678+00
38	4	2025-11-03	IN_PROGRESS	65.00	Work at 65%	26.852200	80.949300	/uploads/m1_2.jpg	1	2025-11-05 09:17:13.862678+00
39	6	2025-11-03	IN_PROGRESS	65.00	Work at 65%	26.852200	80.949300	/uploads/m1_2.jpg	1	2025-11-05 09:17:13.862678+00
40	8	2025-11-03	IN_PROGRESS	65.00	Work at 65%	26.852200	80.949300	/uploads/m1_2.jpg	1	2025-11-05 09:17:13.862678+00
41	10	2025-11-03	IN_PROGRESS	65.00	Work at 65%	26.852200	80.949300	/uploads/m1_2.jpg	1	2025-11-05 09:17:13.862678+00
42	12	2025-11-03	IN_PROGRESS	65.00	Work at 65%	26.852200	80.949300	/uploads/m1_2.jpg	1	2025-11-05 09:17:13.862678+00
\.


--
-- Data for Name: milestones; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.milestones (id, project_id, name, description, planned_start, planned_end, amount, sequence_no, status, created_at) FROM stdin;
1	1	Foundation	Excavation and foundation	2025-10-06	2025-10-26	5000000.00	1	COMPLETED	2025-11-05 09:03:21.212835+00
2	1	Superstructure	Structural works	2025-10-26	2025-12-05	7000000.00	2	IN_PROGRESS	2025-11-05 09:03:21.214375+00
3	1	Foundation	Excavation and foundation	2025-10-06	2025-10-26	5000000.00	1	COMPLETED	2025-11-05 09:04:15.39993+00
4	1	Superstructure	Structural works	2025-10-26	2025-12-05	7000000.00	2	IN_PROGRESS	2025-11-05 09:04:15.401251+00
5	1	Foundation	Excavation and foundation	2025-10-06	2025-10-26	5000000.00	1	COMPLETED	2025-11-05 09:07:08.229585+00
6	1	Superstructure	Structural works	2025-10-26	2025-12-05	7000000.00	2	IN_PROGRESS	2025-11-05 09:07:08.230906+00
7	1	Foundation	Excavation and foundation	2025-10-06	2025-10-26	5000000.00	1	COMPLETED	2025-11-05 09:11:17.643453+00
8	1	Superstructure	Structural works	2025-10-26	2025-12-05	7000000.00	2	IN_PROGRESS	2025-11-05 09:11:17.644769+00
9	1	Foundation	Excavation and foundation	2025-10-06	2025-10-26	5000000.00	1	COMPLETED	2025-11-05 09:13:04.139262+00
10	1	Superstructure	Structural works	2025-10-26	2025-12-05	7000000.00	2	IN_PROGRESS	2025-11-05 09:13:04.140517+00
11	1	Foundation	Excavation and foundation	2025-10-06	2025-10-26	5000000.00	1	COMPLETED	2025-11-05 09:17:13.857972+00
12	1	Superstructure	Structural works	2025-10-26	2025-12-05	7000000.00	2	IN_PROGRESS	2025-11-05 09:17:13.8593+00
13	1	Foundation	Excavation and foundation	2025-10-06	2025-10-26	5000000.00	1	COMPLETED	2025-11-05 09:18:27.108861+00
14	1	Superstructure	Structural works	2025-10-26	2025-12-05	7000000.00	2	IN_PROGRESS	2025-11-05 09:18:27.110343+00
\.


--
-- Data for Name: notifications; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.notifications (id, user_id, type, title, message, is_read, created_at) FROM stdin;
1	1	INFO	Setup Complete	Database initialized with seed data.	f	2025-11-05 09:03:21.226928+00
\.


--
-- Data for Name: payments; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.payments (id, project_id, contract_id, milestone_id, amount, payment_date, status, reference_no, created_at) FROM stdin;
1	1	1	1	4500000.00	2025-10-31	PAID	PAY-001	2025-11-05 09:03:21.223399+00
\.


--
-- Data for Name: projects; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.projects (id, project_code, name, description, department, start_date, end_date, status, estimated_cost, approved_budget, location_id, latitude, longitude, created_by, created_at, updated_at) FROM stdin;
1	PRJ-001	Tourist Information Center - Lucknow	Setup of modern Tourist Information Center with amenities.	UPSTDC	2025-09-06	2026-03-05	ONGOING	25000000.00	22000000.00	2	26.846700	80.946200	1	2025-11-05 09:03:21.204652+00	2025-11-05 09:03:21.204652+00
\.


--
-- Data for Name: refresh_tokens; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.refresh_tokens (id, user_id, token, expires_at, created_at, revoked, revoked_at) FROM stdin;
\.


--
-- Data for Name: roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.roles (id, name, description, created_at) FROM stdin;
1	ADMIN	System administrator with full access	2025-11-05 09:03:21.195534+00
2	DEO	Data Entry Operator	2025-11-05 09:03:21.195534+00
3	ENGINEER	Project Engineer	2025-11-05 09:03:21.195534+00
4	AUDITOR	Auditor for compliance and QA	2025-11-05 09:03:21.195534+00
5	VIEWER	Read-only access	2025-11-05 09:03:21.195534+00
\.


--
-- Data for Name: sites; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.sites (id, project_id, name, description, address, location_id, latitude, longitude, created_at, updated_at) FROM stdin;
1	1	Primary Site	Main TIC building	Hazratganj, Lucknow	2	26.852000	80.949000	2025-11-05 09:03:21.206669+00	2025-11-05 09:03:21.206669+00
2	1	Primary Site	Main TIC building	Hazratganj, Lucknow	2	26.852000	80.949000	2025-11-05 09:04:15.395469+00	2025-11-05 09:04:15.395469+00
3	1	Primary Site	Main TIC building	Hazratganj, Lucknow	2	26.852000	80.949000	2025-11-05 09:07:08.225338+00	2025-11-05 09:07:08.225338+00
4	1	Primary Site	Main TIC building	Hazratganj, Lucknow	2	26.852000	80.949000	2025-11-05 09:11:17.639226+00	2025-11-05 09:11:17.639226+00
5	1	Primary Site	Main TIC building	Hazratganj, Lucknow	2	26.852000	80.949000	2025-11-05 09:13:04.134942+00	2025-11-05 09:13:04.134942+00
6	1	Primary Site	Main TIC building	Hazratganj, Lucknow	2	26.852000	80.949000	2025-11-05 09:17:13.853729+00	2025-11-05 09:17:13.853729+00
7	1	Primary Site	Main TIC building	Hazratganj, Lucknow	2	26.852000	80.949000	2025-11-05 09:18:27.1045+00	2025-11-05 09:18:27.1045+00
\.


--
-- Data for Name: tenders; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.tenders (id, project_id, tender_no, title, description, publish_date, close_date, status, created_at) FROM stdin;
1	1	TN-001	Construction Tender	Construction and interiors	2025-09-21	2025-10-21	AWARDED	2025-11-05 09:03:21.20831+00
\.


--
-- Data for Name: user_roles; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.user_roles (user_id, role_id, assigned_at, assigned_by) FROM stdin;
1	1	2025-11-05 09:03:21.197452+00	\N
\.


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

COPY public.users (id, username, email, password_hash, full_name, phone, status, last_login_at, created_at, updated_at) FROM stdin;
1	admin	admin@uptourism.local	$2b$10$0s7pJc.7uYv4yS9c9wC1MeoJmXkXh3w0GzJdNf4b0jBqLq9Wzqgwy	System Administrator	+910000000000	ACTIVE	\N	2025-11-05 09:03:21.197452+00	2025-11-05 09:03:21.197452+00
\.


--
-- Name: audit_log_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.audit_log_id_seq', 1, false);


--
-- Name: contractors_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.contractors_id_seq', 7, true);


--
-- Name: contracts_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.contracts_id_seq', 1, true);


--
-- Name: documents_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.documents_id_seq', 7, true);


--
-- Name: funds_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.funds_id_seq', 7, true);


--
-- Name: handovers_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.handovers_id_seq', 7, true);


--
-- Name: inspections_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.inspections_id_seq', 28, true);


--
-- Name: locations_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.locations_id_seq', 9, true);


--
-- Name: milestone_updates_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.milestone_updates_id_seq', 56, true);


--
-- Name: milestones_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.milestones_id_seq', 14, true);


--
-- Name: notifications_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.notifications_id_seq', 1, true);


--
-- Name: payments_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.payments_id_seq', 7, true);


--
-- Name: projects_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.projects_id_seq', 1, true);


--
-- Name: roles_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.roles_id_seq', 35, true);


--
-- Name: sites_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.sites_id_seq', 7, true);


--
-- Name: tenders_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.tenders_id_seq', 7, true);


--
-- Name: users_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.users_id_seq', 7, true);


--
-- Name: audit_log audit_log_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT audit_log_pkey PRIMARY KEY (id);


--
-- Name: contractors contractors_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contractors
    ADD CONSTRAINT contractors_pkey PRIMARY KEY (id);


--
-- Name: contractors contractors_registration_no_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contractors
    ADD CONSTRAINT contractors_registration_no_key UNIQUE (registration_no);


--
-- Name: contracts contracts_contract_no_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contracts
    ADD CONSTRAINT contracts_contract_no_key UNIQUE (contract_no);


--
-- Name: contracts contracts_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contracts
    ADD CONSTRAINT contracts_pkey PRIMARY KEY (id);


--
-- Name: documents documents_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_pkey PRIMARY KEY (id);


--
-- Name: funds funds_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.funds
    ADD CONSTRAINT funds_pkey PRIMARY KEY (id);


--
-- Name: handovers handovers_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.handovers
    ADD CONSTRAINT handovers_pkey PRIMARY KEY (id);


--
-- Name: inspections inspections_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inspections
    ADD CONSTRAINT inspections_pkey PRIMARY KEY (id);


--
-- Name: locations locations_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_pkey PRIMARY KEY (id);


--
-- Name: milestone_updates milestone_updates_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.milestone_updates
    ADD CONSTRAINT milestone_updates_pkey PRIMARY KEY (id);


--
-- Name: milestones milestones_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.milestones
    ADD CONSTRAINT milestones_pkey PRIMARY KEY (id);


--
-- Name: notifications notifications_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_pkey PRIMARY KEY (id);


--
-- Name: payments payments_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_pkey PRIMARY KEY (id);


--
-- Name: projects projects_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_pkey PRIMARY KEY (id);


--
-- Name: projects projects_project_code_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_project_code_key UNIQUE (project_code);


--
-- Name: refresh_tokens refresh_tokens_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_pkey PRIMARY KEY (id);


--
-- Name: refresh_tokens refresh_tokens_token_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_token_key UNIQUE (token);


--
-- Name: roles roles_name_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_name_key UNIQUE (name);


--
-- Name: roles roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.roles
    ADD CONSTRAINT roles_pkey PRIMARY KEY (id);


--
-- Name: sites sites_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sites
    ADD CONSTRAINT sites_pkey PRIMARY KEY (id);


--
-- Name: tenders tenders_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tenders
    ADD CONSTRAINT tenders_pkey PRIMARY KEY (id);


--
-- Name: tenders tenders_tender_no_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tenders
    ADD CONSTRAINT tenders_tender_no_key UNIQUE (tender_no);


--
-- Name: user_roles user_roles_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_pkey PRIMARY KEY (user_id, role_id);


--
-- Name: users users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_pkey PRIMARY KEY (id);


--
-- Name: users users_username_key; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.users
    ADD CONSTRAINT users_username_key UNIQUE (username);


--
-- Name: idx_audit_log_created_at; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_audit_log_created_at ON public.audit_log USING btree (created_at);


--
-- Name: idx_contracts_contractor; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_contracts_contractor ON public.contracts USING btree (contractor_id);


--
-- Name: idx_contracts_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_contracts_status ON public.contracts USING btree (status);


--
-- Name: idx_contracts_tender; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_contracts_tender ON public.contracts USING btree (tender_id);


--
-- Name: idx_documents_project; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_documents_project ON public.documents USING btree (project_id);


--
-- Name: idx_funds_project; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_funds_project ON public.funds USING btree (project_id);


--
-- Name: idx_funds_release_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_funds_release_date ON public.funds USING btree (release_date);


--
-- Name: idx_handovers_project; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_handovers_project ON public.handovers USING btree (project_id);


--
-- Name: idx_inspections_project; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_inspections_project ON public.inspections USING btree (project_id);


--
-- Name: idx_inspections_site; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_inspections_site ON public.inspections USING btree (site_id);


--
-- Name: idx_milestone_updates_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_milestone_updates_date ON public.milestone_updates USING btree (update_date);


--
-- Name: idx_milestone_updates_milestone; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_milestone_updates_milestone ON public.milestone_updates USING btree (milestone_id);


--
-- Name: idx_milestone_updates_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_milestone_updates_status ON public.milestone_updates USING btree (status);


--
-- Name: idx_milestones_project; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_milestones_project ON public.milestones USING btree (project_id);


--
-- Name: idx_notifications_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_notifications_user ON public.notifications USING btree (user_id);


--
-- Name: idx_payments_contract; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_payments_contract ON public.payments USING btree (contract_id);


--
-- Name: idx_payments_date; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_payments_date ON public.payments USING btree (payment_date);


--
-- Name: idx_payments_milestone; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_payments_milestone ON public.payments USING btree (milestone_id);


--
-- Name: idx_payments_project; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_payments_project ON public.payments USING btree (project_id);


--
-- Name: idx_projects_code; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_projects_code ON public.projects USING btree (project_code);


--
-- Name: idx_projects_location; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_projects_location ON public.projects USING btree (location_id);


--
-- Name: idx_projects_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_projects_status ON public.projects USING btree (status);


--
-- Name: idx_sites_location; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_sites_location ON public.sites USING btree (location_id);


--
-- Name: idx_sites_project; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_sites_project ON public.sites USING btree (project_id);


--
-- Name: idx_tenders_project; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tenders_project ON public.tenders USING btree (project_id);


--
-- Name: idx_tenders_status; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_tenders_status ON public.tenders USING btree (status);


--
-- Name: idx_user_roles_role; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_roles_role ON public.user_roles USING btree (role_id);


--
-- Name: idx_user_roles_user; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_user_roles_user ON public.user_roles USING btree (user_id);


--
-- Name: idx_users_email; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_email ON public.users USING btree (email);


--
-- Name: idx_users_username; Type: INDEX; Schema: public; Owner: postgres
--

CREATE INDEX idx_users_username ON public.users USING btree (username);


--
-- Name: projects trg_projects_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_projects_updated_at BEFORE UPDATE ON public.projects FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: sites trg_sites_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_sites_updated_at BEFORE UPDATE ON public.sites FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: users trg_users_updated_at; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER trg_users_updated_at BEFORE UPDATE ON public.users FOR EACH ROW EXECUTE FUNCTION public.set_updated_at();


--
-- Name: audit_log audit_log_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.audit_log
    ADD CONSTRAINT audit_log_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: contracts contracts_contractor_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contracts
    ADD CONSTRAINT contracts_contractor_id_fkey FOREIGN KEY (contractor_id) REFERENCES public.contractors(id) ON DELETE RESTRICT;


--
-- Name: contracts contracts_tender_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.contracts
    ADD CONSTRAINT contracts_tender_id_fkey FOREIGN KEY (tender_id) REFERENCES public.tenders(id) ON DELETE CASCADE;


--
-- Name: documents documents_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: documents documents_uploaded_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.documents
    ADD CONSTRAINT documents_uploaded_by_fkey FOREIGN KEY (uploaded_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: funds funds_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.funds
    ADD CONSTRAINT funds_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: handovers handovers_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.handovers
    ADD CONSTRAINT handovers_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: inspections inspections_inspector_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inspections
    ADD CONSTRAINT inspections_inspector_id_fkey FOREIGN KEY (inspector_id) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: inspections inspections_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inspections
    ADD CONSTRAINT inspections_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: inspections inspections_site_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.inspections
    ADD CONSTRAINT inspections_site_id_fkey FOREIGN KEY (site_id) REFERENCES public.sites(id) ON DELETE SET NULL;


--
-- Name: locations locations_parent_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.locations
    ADD CONSTRAINT locations_parent_id_fkey FOREIGN KEY (parent_id) REFERENCES public.locations(id) ON DELETE SET NULL;


--
-- Name: milestone_updates milestone_updates_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.milestone_updates
    ADD CONSTRAINT milestone_updates_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: milestone_updates milestone_updates_milestone_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.milestone_updates
    ADD CONSTRAINT milestone_updates_milestone_id_fkey FOREIGN KEY (milestone_id) REFERENCES public.milestones(id) ON DELETE CASCADE;


--
-- Name: milestones milestones_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.milestones
    ADD CONSTRAINT milestones_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: notifications notifications_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.notifications
    ADD CONSTRAINT notifications_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: payments payments_contract_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_contract_id_fkey FOREIGN KEY (contract_id) REFERENCES public.contracts(id) ON DELETE SET NULL;


--
-- Name: payments payments_milestone_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_milestone_id_fkey FOREIGN KEY (milestone_id) REFERENCES public.milestones(id) ON DELETE SET NULL;


--
-- Name: payments payments_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.payments
    ADD CONSTRAINT payments_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: projects projects_created_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_created_by_fkey FOREIGN KEY (created_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: projects projects_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.projects
    ADD CONSTRAINT projects_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id) ON DELETE SET NULL;


--
-- Name: refresh_tokens refresh_tokens_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.refresh_tokens
    ADD CONSTRAINT refresh_tokens_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: sites sites_location_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sites
    ADD CONSTRAINT sites_location_id_fkey FOREIGN KEY (location_id) REFERENCES public.locations(id) ON DELETE SET NULL;


--
-- Name: sites sites_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.sites
    ADD CONSTRAINT sites_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: tenders tenders_project_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.tenders
    ADD CONSTRAINT tenders_project_id_fkey FOREIGN KEY (project_id) REFERENCES public.projects(id) ON DELETE CASCADE;


--
-- Name: user_roles user_roles_assigned_by_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_assigned_by_fkey FOREIGN KEY (assigned_by) REFERENCES public.users(id) ON DELETE SET NULL;


--
-- Name: user_roles user_roles_role_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_role_id_fkey FOREIGN KEY (role_id) REFERENCES public.roles(id) ON DELETE CASCADE;


--
-- Name: user_roles user_roles_user_id_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.user_roles
    ADD CONSTRAINT user_roles_user_id_fkey FOREIGN KEY (user_id) REFERENCES public.users(id) ON DELETE CASCADE;


--
-- Name: DATABASE myapp; Type: ACL; Schema: -; Owner: postgres
--

GRANT ALL ON DATABASE myapp TO appuser;


--
-- Name: SCHEMA public; Type: ACL; Schema: -; Owner: pg_database_owner
--

GRANT ALL ON SCHEMA public TO appuser;


--
-- Name: TYPE contract_status; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TYPE public.contract_status TO appuser;


--
-- Name: TYPE document_type; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TYPE public.document_type TO appuser;


--
-- Name: TYPE handover_status; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TYPE public.handover_status TO appuser;


--
-- Name: TYPE inspection_outcome; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TYPE public.inspection_outcome TO appuser;


--
-- Name: TYPE milestone_status; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TYPE public.milestone_status TO appuser;


--
-- Name: TYPE notification_type; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TYPE public.notification_type TO appuser;


--
-- Name: TYPE payment_status; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TYPE public.payment_status TO appuser;


--
-- Name: TYPE project_status; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TYPE public.project_status TO appuser;


--
-- Name: TYPE tender_status; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TYPE public.tender_status TO appuser;


--
-- Name: TYPE user_status; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TYPE public.user_status TO appuser;


--
-- Name: FUNCTION armor(bytea); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.armor(bytea) TO appuser;


--
-- Name: FUNCTION armor(bytea, text[], text[]); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.armor(bytea, text[], text[]) TO appuser;


--
-- Name: FUNCTION crypt(text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.crypt(text, text) TO appuser;


--
-- Name: FUNCTION dearmor(text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.dearmor(text) TO appuser;


--
-- Name: FUNCTION decrypt(bytea, bytea, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.decrypt(bytea, bytea, text) TO appuser;


--
-- Name: FUNCTION decrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.decrypt_iv(bytea, bytea, bytea, text) TO appuser;


--
-- Name: FUNCTION digest(bytea, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.digest(bytea, text) TO appuser;


--
-- Name: FUNCTION digest(text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.digest(text, text) TO appuser;


--
-- Name: FUNCTION encrypt(bytea, bytea, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.encrypt(bytea, bytea, text) TO appuser;


--
-- Name: FUNCTION encrypt_iv(bytea, bytea, bytea, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.encrypt_iv(bytea, bytea, bytea, text) TO appuser;


--
-- Name: FUNCTION gen_random_bytes(integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.gen_random_bytes(integer) TO appuser;


--
-- Name: FUNCTION gen_random_uuid(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.gen_random_uuid() TO appuser;


--
-- Name: FUNCTION gen_salt(text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.gen_salt(text) TO appuser;


--
-- Name: FUNCTION gen_salt(text, integer); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.gen_salt(text, integer) TO appuser;


--
-- Name: FUNCTION hmac(bytea, bytea, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.hmac(bytea, bytea, text) TO appuser;


--
-- Name: FUNCTION hmac(text, text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.hmac(text, text, text) TO appuser;


--
-- Name: FUNCTION pgp_armor_headers(text, OUT key text, OUT value text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_armor_headers(text, OUT key text, OUT value text) TO appuser;


--
-- Name: FUNCTION pgp_key_id(bytea); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_key_id(bytea) TO appuser;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_pub_decrypt(bytea, bytea) TO appuser;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_pub_decrypt(bytea, bytea, text) TO appuser;


--
-- Name: FUNCTION pgp_pub_decrypt(bytea, bytea, text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_pub_decrypt(bytea, bytea, text, text) TO appuser;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_pub_decrypt_bytea(bytea, bytea) TO appuser;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_pub_decrypt_bytea(bytea, bytea, text) TO appuser;


--
-- Name: FUNCTION pgp_pub_decrypt_bytea(bytea, bytea, text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_pub_decrypt_bytea(bytea, bytea, text, text) TO appuser;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_pub_encrypt(text, bytea) TO appuser;


--
-- Name: FUNCTION pgp_pub_encrypt(text, bytea, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_pub_encrypt(text, bytea, text) TO appuser;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_pub_encrypt_bytea(bytea, bytea) TO appuser;


--
-- Name: FUNCTION pgp_pub_encrypt_bytea(bytea, bytea, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_pub_encrypt_bytea(bytea, bytea, text) TO appuser;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_sym_decrypt(bytea, text) TO appuser;


--
-- Name: FUNCTION pgp_sym_decrypt(bytea, text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_sym_decrypt(bytea, text, text) TO appuser;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_sym_decrypt_bytea(bytea, text) TO appuser;


--
-- Name: FUNCTION pgp_sym_decrypt_bytea(bytea, text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_sym_decrypt_bytea(bytea, text, text) TO appuser;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_sym_encrypt(text, text) TO appuser;


--
-- Name: FUNCTION pgp_sym_encrypt(text, text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_sym_encrypt(text, text, text) TO appuser;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_sym_encrypt_bytea(bytea, text) TO appuser;


--
-- Name: FUNCTION pgp_sym_encrypt_bytea(bytea, text, text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.pgp_sym_encrypt_bytea(bytea, text, text) TO appuser;


--
-- Name: FUNCTION set_updated_at(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.set_updated_at() TO appuser;


--
-- Name: FUNCTION uuid_generate_v1(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.uuid_generate_v1() TO appuser;


--
-- Name: FUNCTION uuid_generate_v1mc(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.uuid_generate_v1mc() TO appuser;


--
-- Name: FUNCTION uuid_generate_v3(namespace uuid, name text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.uuid_generate_v3(namespace uuid, name text) TO appuser;


--
-- Name: FUNCTION uuid_generate_v4(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.uuid_generate_v4() TO appuser;


--
-- Name: FUNCTION uuid_generate_v5(namespace uuid, name text); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.uuid_generate_v5(namespace uuid, name text) TO appuser;


--
-- Name: FUNCTION uuid_nil(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.uuid_nil() TO appuser;


--
-- Name: FUNCTION uuid_ns_dns(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.uuid_ns_dns() TO appuser;


--
-- Name: FUNCTION uuid_ns_oid(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.uuid_ns_oid() TO appuser;


--
-- Name: FUNCTION uuid_ns_url(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.uuid_ns_url() TO appuser;


--
-- Name: FUNCTION uuid_ns_x500(); Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON FUNCTION public.uuid_ns_x500() TO appuser;


--
-- Name: TABLE audit_log; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.audit_log TO appuser;


--
-- Name: SEQUENCE audit_log_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.audit_log_id_seq TO appuser;


--
-- Name: TABLE contractors; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.contractors TO appuser;


--
-- Name: SEQUENCE contractors_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.contractors_id_seq TO appuser;


--
-- Name: TABLE contracts; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.contracts TO appuser;


--
-- Name: SEQUENCE contracts_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.contracts_id_seq TO appuser;


--
-- Name: TABLE documents; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.documents TO appuser;


--
-- Name: SEQUENCE documents_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.documents_id_seq TO appuser;


--
-- Name: TABLE funds; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.funds TO appuser;


--
-- Name: SEQUENCE funds_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.funds_id_seq TO appuser;


--
-- Name: TABLE handovers; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.handovers TO appuser;


--
-- Name: SEQUENCE handovers_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.handovers_id_seq TO appuser;


--
-- Name: TABLE inspections; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.inspections TO appuser;


--
-- Name: SEQUENCE inspections_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.inspections_id_seq TO appuser;


--
-- Name: TABLE locations; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.locations TO appuser;


--
-- Name: SEQUENCE locations_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.locations_id_seq TO appuser;


--
-- Name: TABLE milestone_updates; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.milestone_updates TO appuser;


--
-- Name: SEQUENCE milestone_updates_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.milestone_updates_id_seq TO appuser;


--
-- Name: TABLE milestones; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.milestones TO appuser;


--
-- Name: SEQUENCE milestones_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.milestones_id_seq TO appuser;


--
-- Name: TABLE notifications; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.notifications TO appuser;


--
-- Name: SEQUENCE notifications_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.notifications_id_seq TO appuser;


--
-- Name: TABLE payments; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.payments TO appuser;


--
-- Name: SEQUENCE payments_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.payments_id_seq TO appuser;


--
-- Name: TABLE projects; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.projects TO appuser;


--
-- Name: SEQUENCE projects_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.projects_id_seq TO appuser;


--
-- Name: TABLE refresh_tokens; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.refresh_tokens TO appuser;


--
-- Name: TABLE roles; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.roles TO appuser;


--
-- Name: SEQUENCE roles_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.roles_id_seq TO appuser;


--
-- Name: TABLE sites; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.sites TO appuser;


--
-- Name: SEQUENCE sites_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.sites_id_seq TO appuser;


--
-- Name: TABLE tenders; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.tenders TO appuser;


--
-- Name: SEQUENCE tenders_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.tenders_id_seq TO appuser;


--
-- Name: TABLE user_roles; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.user_roles TO appuser;


--
-- Name: TABLE users; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.users TO appuser;


--
-- Name: SEQUENCE users_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.users_id_seq TO appuser;


--
-- Name: TABLE v_contractor_performance; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.v_contractor_performance TO appuser;


--
-- Name: TABLE v_fund_utilization; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.v_fund_utilization TO appuser;


--
-- Name: TABLE v_geo_progress; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.v_geo_progress TO appuser;


--
-- Name: TABLE v_project_overview; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.v_project_overview TO appuser;


--
-- Name: DEFAULT PRIVILEGES FOR SEQUENCES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON SEQUENCES TO appuser;


--
-- Name: DEFAULT PRIVILEGES FOR TYPES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TYPES TO appuser;


--
-- Name: DEFAULT PRIVILEGES FOR FUNCTIONS; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON FUNCTIONS TO appuser;


--
-- Name: DEFAULT PRIVILEGES FOR TABLES; Type: DEFAULT ACL; Schema: public; Owner: postgres
--

ALTER DEFAULT PRIVILEGES FOR ROLE postgres IN SCHEMA public GRANT ALL ON TABLES TO appuser;


--
-- PostgreSQL database dump complete
--

\unrestrict 2BmqKLP4qaA2e7qywEJrceMAhUxqZobOPtavxRPhmDvMVgvfTWhdc6WNXaVLudg

