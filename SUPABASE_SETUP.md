# Supabase Setup Guide for CRM Web App

## Prerequisites
1. Create a Supabase account at https://supabase.com
2. Create a new project in Supabase
3. Get your project URL and anon key from Project Settings > API

## Configuration
1. Update `lib/config/supabase_config.dart` with your actual values:
   ```dart
   static const String supabaseUrl = 'https://your-project-ref.supabase.co';
   static const String supabaseAnonKey = 'your-anon-key-here';
   ```

## Database Schema

Run the following SQL commands in your Supabase SQL editor to create the required tables:

### 1. Doctors Table
```sql
-- Create doctors table
CREATE TABLE doctors (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    specialty VARCHAR(255) NOT NULL,
    area VARCHAR(255) NOT NULL,
    date_of_birth DATE,
    phone_no VARCHAR(20) NOT NULL,
    marriage_anniversary DATE,
    call_days TEXT[] DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Create indexes for better performance
CREATE INDEX idx_doctors_name ON doctors(name);
CREATE INDEX idx_doctors_specialty ON doctors(specialty);
CREATE INDEX idx_doctors_area ON doctors(area);
CREATE INDEX idx_doctors_phone ON doctors(phone_no);

-- Enable Row Level Security (RLS)
ALTER TABLE doctors ENABLE ROW LEVEL SECURITY;

-- Create policy to allow all operations for authenticated users
-- (adjust according to your authentication requirements)
CREATE POLICY "Enable all operations for authenticated users" ON doctors
FOR ALL USING (true);
```

### 2. Areas Table
```sql
-- Create areas table
CREATE TABLE areas (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    area VARCHAR(255) NOT NULL,
    headquarter VARCHAR(255) NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    UNIQUE(area, headquarter)
);

-- Create indexes
CREATE INDEX idx_areas_area ON areas(area);
CREATE INDEX idx_areas_headquarter ON areas(headquarter);

-- Enable RLS
ALTER TABLE areas ENABLE ROW LEVEL SECURITY;

-- Create policy
CREATE POLICY "Enable all operations for authenticated users" ON areas
FOR ALL USING (true);
```

### 3. Specialties Table
```sql
-- Create specialties table
CREATE TABLE specialties (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Create index
CREATE INDEX idx_specialties_name ON specialties(name);

-- Enable RLS
ALTER TABLE specialties ENABLE ROW LEVEL SECURITY;

-- Create policy
CREATE POLICY "Enable all operations for authenticated users" ON specialties
FOR ALL USING (true);
```

### 4. Medical Representatives Table
```sql
-- Create medical_representatives table
CREATE TABLE medical_representatives (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    age INTEGER,
    sex VARCHAR(10),
    phone_no VARCHAR(20) NOT NULL,
    address TEXT,
    area_name VARCHAR(255),
    account_number VARCHAR(50),
    bank_name VARCHAR(255),
    ifsc_code VARCHAR(20),
    headquarter VARCHAR(255),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Create indexes
CREATE INDEX idx_mrs_name ON medical_representatives(name);
CREATE INDEX idx_mrs_area ON medical_representatives(area_name);
CREATE INDEX idx_mrs_phone ON medical_representatives(phone_no);

-- Enable RLS
ALTER TABLE medical_representatives ENABLE ROW LEVEL SECURITY;

-- Create policy
CREATE POLICY "Enable all operations for authenticated users" ON medical_representatives
FOR ALL USING (true);
```

### 5. Medical Facilities Table
```sql
-- Create medical_facilities table
CREATE TABLE medical_facilities (
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

-- Create indexes
CREATE INDEX idx_medicals_name ON medical_facilities(name);
CREATE INDEX idx_medicals_area ON medical_facilities(area);
CREATE INDEX idx_medicals_doctor ON medical_facilities(attached_doctor);

-- Enable RLS
ALTER TABLE medical_facilities ENABLE ROW LEVEL SECURITY;

-- Create policy
CREATE POLICY "Enable all operations for authenticated users" ON medical_facilities
FOR ALL USING (true);
```

### 6. Stockists Table
```sql
-- Create stockists table
CREATE TABLE stockists (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    company VARCHAR(255) NOT NULL,
    area VARCHAR(255) NOT NULL,
    license_number VARCHAR(100),
    contact_person VARCHAR(255),
    phone_no VARCHAR(20) NOT NULL,
    address TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Create indexes
CREATE INDEX idx_stockists_name ON stockists(name);
CREATE INDEX idx_stockists_company ON stockists(company);
CREATE INDEX idx_stockists_area ON stockists(area);

-- Enable RLS
ALTER TABLE stockists ENABLE ROW LEVEL SECURITY;

-- Create policy
CREATE POLICY "Enable all operations for authenticated users" ON stockists
FOR ALL USING (true);
```

### 7. Headquarters Table
```sql
-- Create headquarters table
CREATE TABLE headquarters (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    name VARCHAR(255) NOT NULL UNIQUE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT timezone('utc'::text, now()) NOT NULL
);

-- Create index
CREATE INDEX idx_headquarters_name ON headquarters(name);

-- Enable RLS
ALTER TABLE headquarters ENABLE ROW LEVEL SECURITY;

-- Create policy
CREATE POLICY "Enable all operations for authenticated users" ON headquarters
FOR ALL USING (true);
```

### 8. Update Triggers (Optional - for automatic updated_at timestamps)
```sql
-- Create function to update updated_at column
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = timezone('utc'::text, now());
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for all tables
CREATE TRIGGER update_doctors_updated_at BEFORE UPDATE ON doctors
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_areas_updated_at BEFORE UPDATE ON areas
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_specialties_updated_at BEFORE UPDATE ON specialties
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_medical_representatives_updated_at BEFORE UPDATE ON medical_representatives
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_medical_facilities_updated_at BEFORE UPDATE ON medical_facilities
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_stockists_updated_at BEFORE UPDATE ON stockists
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

CREATE TRIGGER update_headquarters_updated_at BEFORE UPDATE ON headquarters
FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
```

## Testing the Setup

After running the schema, you can test the connection by:

1. Running the Flutter app
2. Adding a new doctor through the UI
3. Checking if the data appears in your Supabase dashboard

## Security Considerations

The current setup uses permissive RLS policies. For production, consider:

1. Implementing proper user authentication
2. Creating more restrictive RLS policies based on user roles
3. Adding data validation constraints
4. Setting up proper backup and monitoring

## Next Steps

1. Run the SQL schema in your Supabase project
2. Update the configuration file with your credentials
3. Test the application
4. Customize the security policies as needed
