-- CRM Web App - Safe Schema Setup
-- This version can be run multiple times safely
-- Run this in your Supabase SQL Editor

-- ================================================================================
-- SAFE TABLE CREATION (with proper checks)
-- ================================================================================

-- 1. Headquarters Table
CREATE TABLE IF NOT EXISTS headquarters (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 2. Specialties Table  
CREATE TABLE IF NOT EXISTS specialties (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 3. Areas Table
CREATE TABLE IF NOT EXISTS areas (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    area VARCHAR(255) NOT NULL,
    headquarter VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    UNIQUE(area, headquarter)
);

-- 4. Medical Representatives Table (with multi-select support)
CREATE TABLE IF NOT EXISTS medical_representatives (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    age INTEGER,
    sex VARCHAR(10),
    phone_no VARCHAR(20) NOT NULL,
    address TEXT,
    area_names TEXT[] DEFAULT '{}',
    account_number VARCHAR(50),
    bank_name VARCHAR(255),
    ifsc_code VARCHAR(20),
    headquarters TEXT[] DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 5. Doctors Table
CREATE TABLE IF NOT EXISTS doctors (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    specialty VARCHAR(255) NOT NULL,
    area VARCHAR(255) NOT NULL,
    headquarter VARCHAR(255) NOT NULL,
    date_of_birth DATE,
    phone_no VARCHAR(20) NOT NULL,
    marriage_anniversary DATE,
    call_days TEXT[] DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 6. Medical Facilities Table
CREATE TABLE IF NOT EXISTS medical_facilities (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    headquarter VARCHAR(255) NOT NULL,
    area VARCHAR(255) NOT NULL,
    contact_person VARCHAR(255) NOT NULL,
    phone_no VARCHAR(20) NOT NULL,
    address TEXT NOT NULL,
    attached_doctor VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- 7. Stockists Table
CREATE TABLE IF NOT EXISTS stockists (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    company VARCHAR(255) NOT NULL,
    contact VARCHAR(255) NOT NULL,
    address TEXT NOT NULL,
    area VARCHAR(255) NOT NULL,
    headquarter VARCHAR(255) NOT NULL,
    license_number VARCHAR(100),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- ================================================================================
-- CREATE INDEXES (safe to run multiple times)
-- ================================================================================

CREATE INDEX IF NOT EXISTS idx_headquarters_name ON headquarters(name);
CREATE INDEX IF NOT EXISTS idx_specialties_name ON specialties(name);
CREATE INDEX IF NOT EXISTS idx_areas_area ON areas(area);
CREATE INDEX IF NOT EXISTS idx_areas_headquarter ON areas(headquarter);
CREATE INDEX IF NOT EXISTS idx_mrs_name ON medical_representatives(name);
CREATE INDEX IF NOT EXISTS idx_mrs_phone ON medical_representatives(phone_no);
CREATE INDEX IF NOT EXISTS idx_mrs_area_names ON medical_representatives USING GIN(area_names);
CREATE INDEX IF NOT EXISTS idx_mrs_headquarters ON medical_representatives USING GIN(headquarters);
CREATE INDEX IF NOT EXISTS idx_doctors_name ON doctors(name);
CREATE INDEX IF NOT EXISTS idx_doctors_specialty ON doctors(specialty);
CREATE INDEX IF NOT EXISTS idx_doctors_area ON doctors(area);
CREATE INDEX IF NOT EXISTS idx_doctors_headquarter ON doctors(headquarter);
CREATE INDEX IF NOT EXISTS idx_doctors_phone ON doctors(phone_no);
CREATE INDEX IF NOT EXISTS idx_medicals_name ON medical_facilities(name);
CREATE INDEX IF NOT EXISTS idx_medicals_area ON medical_facilities(area);
CREATE INDEX IF NOT EXISTS idx_medicals_headquarter ON medical_facilities(headquarter);
CREATE INDEX IF NOT EXISTS idx_medicals_doctor ON medical_facilities(attached_doctor);
CREATE INDEX IF NOT EXISTS idx_stockists_name ON stockists(name);
CREATE INDEX IF NOT EXISTS idx_stockists_company ON stockists(company);
CREATE INDEX IF NOT EXISTS idx_stockists_area ON stockists(area);
CREATE INDEX IF NOT EXISTS idx_stockists_headquarter ON stockists(headquarter);

-- ================================================================================
-- ENABLE ROW LEVEL SECURITY
-- ================================================================================

ALTER TABLE headquarters ENABLE ROW LEVEL SECURITY;
ALTER TABLE specialties ENABLE ROW LEVEL SECURITY;
ALTER TABLE areas ENABLE ROW LEVEL SECURITY;
ALTER TABLE medical_representatives ENABLE ROW LEVEL SECURITY;
ALTER TABLE doctors ENABLE ROW LEVEL SECURITY;
ALTER TABLE medical_facilities ENABLE ROW LEVEL SECURITY;
ALTER TABLE stockists ENABLE ROW LEVEL SECURITY;

-- ================================================================================
-- CREATE/UPDATE TRIGGERS
-- ================================================================================

-- Create or replace the trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = timezone('utc'::text, now());
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Drop and recreate triggers (safe approach)
DROP TRIGGER IF EXISTS update_headquarters_updated_at ON headquarters;
CREATE TRIGGER update_headquarters_updated_at BEFORE UPDATE ON headquarters
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_specialties_updated_at ON specialties;
CREATE TRIGGER update_specialties_updated_at BEFORE UPDATE ON specialties
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_areas_updated_at ON areas;
CREATE TRIGGER update_areas_updated_at BEFORE UPDATE ON areas
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_medical_representatives_updated_at ON medical_representatives;
CREATE TRIGGER update_medical_representatives_updated_at BEFORE UPDATE ON medical_representatives
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_doctors_updated_at ON doctors;
CREATE TRIGGER update_doctors_updated_at BEFORE UPDATE ON doctors
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_medical_facilities_updated_at ON medical_facilities;
CREATE TRIGGER update_medical_facilities_updated_at BEFORE UPDATE ON medical_facilities
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

DROP TRIGGER IF EXISTS update_stockists_updated_at ON stockists;
CREATE TRIGGER update_stockists_updated_at BEFORE UPDATE ON stockists
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- ================================================================================
-- SAMPLE DATA (safe inserts)
-- ================================================================================

INSERT INTO headquarters (name) VALUES 
    ('Mumbai HQ'),
    ('Delhi HQ'),
    ('Bangalore HQ'),
    ('Chennai HQ')
ON CONFLICT (name) DO NOTHING;

INSERT INTO specialties (name) VALUES 
    ('Cardiology'),
    ('Orthopedics'),
    ('Neurology'),
    ('Pediatrics'),
    ('General Medicine')
ON CONFLICT (name) DO NOTHING;

INSERT INTO areas (area, headquarter) VALUES 
    ('Andheri', 'Mumbai HQ'),
    ('Bandra', 'Mumbai HQ'),
    ('Connaught Place', 'Delhi HQ'),
    ('Karol Bagh', 'Delhi HQ'),
    ('Koramangala', 'Bangalore HQ'),
    ('Whitefield', 'Bangalore HQ'),
    ('T. Nagar', 'Chennai HQ'),
    ('Anna Nagar', 'Chennai HQ')
ON CONFLICT (area, headquarter) DO NOTHING;

-- ================================================================================
-- SUCCESS MESSAGE
-- ================================================================================

SELECT 'Schema setup completed successfully! Tables, indexes, and triggers are ready.' as status;
