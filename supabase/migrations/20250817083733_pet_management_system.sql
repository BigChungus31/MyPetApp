-- Location: supabase/migrations/20250817083733_pet_management_system.sql
-- Schema Analysis: Existing schema has only Businesses table for NCR vet clinics
-- Integration Type: NEW_MODULE - Complete pet management system
-- Dependencies: References existing Businesses table for vet clinic data

-- 1. Create Custom Types
CREATE TYPE public.pet_gender AS ENUM ('male', 'female');
CREATE TYPE public.pet_size AS ENUM ('small', 'medium', 'large', 'extra_large');
CREATE TYPE public.appointment_status AS ENUM ('pending', 'confirmed', 'completed', 'cancelled');
CREATE TYPE public.consultation_status AS ENUM ('scheduled', 'in_progress', 'completed', 'cancelled');
CREATE TYPE public.order_status AS ENUM ('pending', 'confirmed', 'preparing', 'out_for_delivery', 'delivered', 'cancelled');
CREATE TYPE public.insurance_status AS ENUM ('active', 'pending', 'expired', 'cancelled');

-- 2. Core User Management
CREATE TABLE public.user_profiles (
    id UUID PRIMARY KEY REFERENCES auth.users(id) ON DELETE CASCADE,
    email TEXT NOT NULL UNIQUE,
    full_name TEXT NOT NULL,
    phone_number TEXT,
    address TEXT,
    city TEXT DEFAULT 'Delhi',
    is_verified BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 3. Pet Management
CREATE TABLE public.pets (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    owner_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    name TEXT NOT NULL,
    breed TEXT NOT NULL,
    gender public.pet_gender NOT NULL,
    age_years INTEGER NOT NULL CHECK (age_years >= 0),
    age_months INTEGER NOT NULL CHECK (age_months >= 0 AND age_months < 12),
    weight_kg DECIMAL(5,2) CHECK (weight_kg > 0),
    size_category public.pet_size,
    photo_url TEXT,
    is_active BOOLEAN DEFAULT true,
    medical_notes TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 4. Vaccination Tracking
CREATE TABLE public.vaccinations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    pet_id UUID REFERENCES public.pets(id) ON DELETE CASCADE,
    vaccine_name TEXT NOT NULL,
    vaccination_date DATE NOT NULL,
    next_due_date DATE,
    veterinarian_name TEXT,
    batch_number TEXT,
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 5. Pet Insurance
CREATE TABLE public.pet_insurance (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    pet_id UUID REFERENCES public.pets(id) ON DELETE CASCADE,
    provider_name TEXT NOT NULL,
    policy_number TEXT NOT NULL,
    coverage_amount DECIMAL(10,2),
    premium_amount DECIMAL(8,2),
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    status public.insurance_status DEFAULT 'pending',
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 6. Appointment Booking (Grooming & Clinic)
CREATE TABLE public.appointments (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    pet_id UUID REFERENCES public.pets(id) ON DELETE CASCADE,
    business_id TEXT, -- References Businesses table (no FK since it has no primary key)
    appointment_type TEXT NOT NULL, -- 'grooming' or 'clinic'
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    status public.appointment_status DEFAULT 'pending',
    service_details TEXT,
    estimated_cost DECIMAL(8,2),
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 7. E-Consultations
CREATE TABLE public.consultations (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    pet_id UUID REFERENCES public.pets(id) ON DELETE CASCADE,
    vet_name TEXT NOT NULL,
    vet_specialization TEXT,
    consultation_fee DECIMAL(8,2) NOT NULL,
    scheduled_datetime TIMESTAMPTZ NOT NULL,
    status public.consultation_status DEFAULT 'scheduled',
    meeting_link TEXT,
    prescription TEXT,
    notes TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 8. Pet Blinkit Delivery Orders
CREATE TABLE public.delivery_orders (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    user_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    order_total DECIMAL(10,2) NOT NULL,
    delivery_address TEXT NOT NULL,
    status public.order_status DEFAULT 'pending',
    estimated_delivery_time TIMESTAMPTZ,
    actual_delivery_time TIMESTAMPTZ,
    delivery_fee DECIMAL(6,2) DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE public.order_items (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    order_id UUID REFERENCES public.delivery_orders(id) ON DELETE CASCADE,
    product_name TEXT NOT NULL,
    product_category TEXT NOT NULL, -- 'food', 'toys', 'accessories', 'medicine'
    quantity INTEGER NOT NULL CHECK (quantity > 0),
    unit_price DECIMAL(8,2) NOT NULL,
    total_price DECIMAL(8,2) NOT NULL,
    product_image_url TEXT
);

-- 9. Pet-Friendly Cafes & Venues
CREATE TABLE public.pet_friendly_venues (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    address TEXT NOT NULL,
    city TEXT DEFAULT 'Delhi',
    venue_type TEXT NOT NULL, -- 'cafe', 'restaurant', 'park', 'hotel'
    rating DECIMAL(2,1) CHECK (rating >= 0 AND rating <= 5),
    pet_amenities TEXT[], -- Array of amenities like ['pet_menu', 'water_bowls', 'pet_area']
    contact_number TEXT,
    opening_hours TEXT,
    website_url TEXT,
    image_url TEXT,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 10. Blog Posts for Community
CREATE TABLE public.blog_posts (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    author_id UUID REFERENCES public.user_profiles(id) ON DELETE CASCADE,
    title TEXT NOT NULL,
    content TEXT NOT NULL,
    post_type TEXT NOT NULL, -- 'clinic_review', 'vet_review', 'event', 'cafe_review'
    related_business_id TEXT, -- References Businesses table
    tags TEXT[],
    image_urls TEXT[],
    likes_count INTEGER DEFAULT 0,
    is_published BOOLEAN DEFAULT true,
    created_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMPTZ DEFAULT CURRENT_TIMESTAMP
);

-- 11. Essential Indexes
CREATE INDEX idx_pets_owner_id ON public.pets(owner_id);
CREATE INDEX idx_pets_active ON public.pets(is_active) WHERE is_active = true;
CREATE INDEX idx_vaccinations_pet_id ON public.vaccinations(pet_id);
CREATE INDEX idx_vaccinations_due_date ON public.vaccinations(next_due_date) WHERE next_due_date IS NOT NULL;
CREATE INDEX idx_appointments_pet_id ON public.appointments(pet_id);
CREATE INDEX idx_appointments_date ON public.appointments(appointment_date);
CREATE INDEX idx_consultations_pet_id ON public.consultations(pet_id);
CREATE INDEX idx_consultations_datetime ON public.consultations(scheduled_datetime);
CREATE INDEX idx_delivery_orders_user_id ON public.delivery_orders(user_id);
CREATE INDEX idx_order_items_order_id ON public.order_items(order_id);
CREATE INDEX idx_blog_posts_author_id ON public.blog_posts(author_id);
CREATE INDEX idx_blog_posts_type ON public.blog_posts(post_type);
CREATE INDEX idx_venues_city ON public.pet_friendly_venues(city);
CREATE INDEX idx_venues_type ON public.pet_friendly_venues(venue_type);

-- 12. Enable RLS
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.pets ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.vaccinations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.pet_insurance ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.appointments ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.consultations ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.delivery_orders ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.order_items ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.pet_friendly_venues ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.blog_posts ENABLE ROW LEVEL SECURITY;

-- 13. RLS Policies - Pattern 1: Core User Tables
CREATE POLICY "users_manage_own_user_profiles"
ON public.user_profiles
FOR ALL
TO authenticated
USING (id = auth.uid())
WITH CHECK (id = auth.uid());

-- Pattern 2: Simple User Ownership
CREATE POLICY "users_manage_own_pets"
ON public.pets
FOR ALL
TO authenticated
USING (owner_id = auth.uid())
WITH CHECK (owner_id = auth.uid());

CREATE POLICY "users_manage_pet_vaccinations"
ON public.vaccinations
FOR ALL
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM public.pets p 
        WHERE p.id = vaccinations.pet_id AND p.owner_id = auth.uid()
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1 FROM public.pets p 
        WHERE p.id = vaccinations.pet_id AND p.owner_id = auth.uid()
    )
);

CREATE POLICY "users_manage_pet_insurance"
ON public.pet_insurance
FOR ALL
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM public.pets p 
        WHERE p.id = pet_insurance.pet_id AND p.owner_id = auth.uid()
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1 FROM public.pets p 
        WHERE p.id = pet_insurance.pet_id AND p.owner_id = auth.uid()
    )
);

CREATE POLICY "users_manage_pet_appointments"
ON public.appointments
FOR ALL
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM public.pets p 
        WHERE p.id = appointments.pet_id AND p.owner_id = auth.uid()
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1 FROM public.pets p 
        WHERE p.id = appointments.pet_id AND p.owner_id = auth.uid()
    )
);

CREATE POLICY "users_manage_pet_consultations"
ON public.consultations
FOR ALL
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM public.pets p 
        WHERE p.id = consultations.pet_id AND p.owner_id = auth.uid()
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1 FROM public.pets p 
        WHERE p.id = consultations.pet_id AND p.owner_id = auth.uid()
    )
);

CREATE POLICY "users_manage_own_delivery_orders"
ON public.delivery_orders
FOR ALL
TO authenticated
USING (user_id = auth.uid())
WITH CHECK (user_id = auth.uid());

CREATE POLICY "users_manage_order_items"
ON public.order_items
FOR ALL
TO authenticated
USING (
    EXISTS (
        SELECT 1 FROM public.delivery_orders do 
        WHERE do.id = order_items.order_id AND do.user_id = auth.uid()
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1 FROM public.delivery_orders do 
        WHERE do.id = order_items.order_id AND do.user_id = auth.uid()
    )
);

-- Pattern 4: Public Read, Private Write
CREATE POLICY "public_can_read_venues"
ON public.pet_friendly_venues
FOR SELECT
TO public
USING (true);

CREATE POLICY "authenticated_users_write_venues"
ON public.pet_friendly_venues
FOR INSERT, UPDATE, DELETE
TO authenticated
USING (true)
WITH CHECK (true);

CREATE POLICY "public_can_read_published_blog_posts"
ON public.blog_posts
FOR SELECT
TO public
USING (is_published = true);

CREATE POLICY "authors_manage_own_blog_posts"
ON public.blog_posts
FOR ALL
TO authenticated
USING (author_id = auth.uid())
WITH CHECK (author_id = auth.uid());

-- 14. Automatic user profile creation trigger
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER
SECURITY DEFINER
LANGUAGE plpgsql
AS $$
BEGIN
    INSERT INTO public.user_profiles (id, email, full_name, phone_number)
    VALUES (
        NEW.id, 
        NEW.email, 
        COALESCE(NEW.raw_user_meta_data->>'full_name', split_part(NEW.email, '@', 1)),
        NEW.raw_user_meta_data->>'phone'
    );
    RETURN NEW;
END;
$$;

CREATE TRIGGER on_auth_user_created
    AFTER INSERT ON auth.users
    FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- 15. Storage Buckets for Pet Images
INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
    'pet-profiles',
    'pet-profiles',
    true,
    5242880, -- 5MB limit
    ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/jpg']
);

INSERT INTO storage.buckets (id, name, public, file_size_limit, allowed_mime_types)
VALUES (
    'venue-images',
    'venue-images', 
    true,
    10485760, -- 10MB limit
    ARRAY['image/jpeg', 'image/png', 'image/webp', 'image/jpg']
);

-- Storage RLS Policies
CREATE POLICY "users_upload_pet_images"
ON storage.objects
FOR INSERT
TO authenticated
WITH CHECK (
    bucket_id = 'pet-profiles'
    AND (storage.foldername(name))[1] = auth.uid()::text
);

CREATE POLICY "public_view_pet_images"
ON storage.objects
FOR SELECT
TO public
USING (bucket_id = 'pet-profiles');

CREATE POLICY "users_manage_own_pet_images"
ON storage.objects
FOR UPDATE, DELETE
TO authenticated
USING (
    bucket_id = 'pet-profiles' 
    AND (storage.foldername(name))[1] = auth.uid()::text
);

CREATE POLICY "public_view_venue_images"
ON storage.objects
FOR SELECT
TO public
USING (bucket_id = 'venue-images');

CREATE POLICY "authenticated_manage_venue_images"
ON storage.objects
FOR INSERT, UPDATE, DELETE
TO authenticated
WITH CHECK (bucket_id = 'venue-images');

-- 16. Mock Data
DO $$
DECLARE
    user1_id UUID := gen_random_uuid();
    user2_id UUID := gen_random_uuid();
    pet1_id UUID := gen_random_uuid();
    pet2_id UUID := gen_random_uuid();
    order1_id UUID := gen_random_uuid();
    venue1_id UUID := gen_random_uuid();
    venue2_id UUID := gen_random_uuid();
BEGIN
    -- Create auth users with complete field structure
    INSERT INTO auth.users (
        id, instance_id, aud, role, email, encrypted_password, email_confirmed_at,
        created_at, updated_at, raw_user_meta_data, raw_app_meta_data,
        is_sso_user, is_anonymous, confirmation_token, confirmation_sent_at,
        recovery_token, recovery_sent_at, email_change_token_new, email_change,
        email_change_sent_at, email_change_token_current, email_change_confirm_status,
        reauthentication_token, reauthentication_sent_at, phone, phone_change,
        phone_change_token, phone_change_sent_at
    ) VALUES
        (user1_id, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'sarah.owner@example.com', crypt('petlover123', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "Sarah Kumar", "phone": "+91-9876543210"}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null),
        (user2_id, '00000000-0000-0000-0000-000000000000', 'authenticated', 'authenticated',
         'rahul.petowner@example.com', crypt('doglover456', gen_salt('bf', 10)), now(), now(), now(),
         '{"full_name": "Rahul Sharma", "phone": "+91-9123456789"}'::jsonb, '{"provider": "email", "providers": ["email"]}'::jsonb,
         false, false, '', null, '', null, '', '', null, '', 0, '', null, null, '', '', null);

    -- Create pets
    INSERT INTO public.pets (id, owner_id, name, breed, gender, age_years, age_months, weight_kg, size_category, photo_url, medical_notes)
    VALUES
        (pet1_id, user1_id, 'Luna', 'Golden Retriever', 'female', 3, 6, 25.5, 'large', 
         'https://images.unsplash.com/photo-1552053831-71594a27632d?w=400', 'Healthy and active. Regular checkups needed.'),
        (pet2_id, user2_id, 'Max', 'German Shepherd', 'male', 2, 0, 32.0, 'large',
         'https://images.unsplash.com/photo-1605568427561-40dd23c2acea?w=400', 'Slight hip dysplasia. Monitor weight.');

    -- Create vaccinations
    INSERT INTO public.vaccinations (pet_id, vaccine_name, vaccination_date, next_due_date, veterinarian_name, batch_number, notes)
    VALUES
        (pet1_id, 'Rabies Vaccine', '2024-06-15', '2025-06-15', 'Dr. Priya Mehta', 'RB2024-456', 'Annual booster required'),
        (pet1_id, 'DHPP Vaccine', '2024-07-01', '2025-07-01', 'Dr. Priya Mehta', 'DH2024-789', 'Core vaccine series complete'),
        (pet2_id, 'Rabies Vaccine', '2024-05-20', '2025-05-20', 'Dr. Amit Gupta', 'RB2024-123', 'First vaccination series'),
        (pet2_id, 'DHPP Vaccine', '2024-06-10', '2025-06-10', 'Dr. Amit Gupta', 'DH2024-456', 'Booster due next year');

    -- Create pet insurance
    INSERT INTO public.pet_insurance (pet_id, provider_name, policy_number, coverage_amount, premium_amount, start_date, end_date, status)
    VALUES
        (pet1_id, 'PetCare Insurance', 'PC-2024-001234', 200000.00, 12000.00, '2024-01-01', '2024-12-31', 'active'),
        (pet2_id, 'Animal Health Plus', 'AHP-2024-005678', 150000.00, 8000.00, '2024-03-01', '2025-02-28', 'active');

    -- Create appointments
    INSERT INTO public.appointments (pet_id, appointment_type, appointment_date, appointment_time, status, service_details, estimated_cost, notes)
    VALUES
        (pet1_id, 'grooming', '2024-12-25', '10:00:00', 'confirmed', 'Full grooming package with nail trimming', 2500.00, 'Sensitive to loud noises'),
        (pet2_id, 'clinic', '2024-12-28', '14:30:00', 'pending', 'Routine checkup and vaccination', 1500.00, 'Annual health screening');

    -- Create consultations
    INSERT INTO public.consultations (pet_id, vet_name, vet_specialization, consultation_fee, scheduled_datetime, status, meeting_link, notes)
    VALUES
        (pet1_id, 'Dr. Kavya Reddy', 'Dermatology', 800.00, '2024-12-26 16:00:00+05:30', 'scheduled', 'https://meet.google.com/xyz-abc-def', 'Skin allergy consultation'),
        (pet2_id, 'Dr. Rajesh Kumar', 'Orthopedics', 1200.00, '2024-12-30 11:00:00+05:30', 'scheduled', 'https://zoom.us/j/123456789', 'Hip dysplasia follow-up');

    -- Create delivery order
    INSERT INTO public.delivery_orders (id, user_id, order_total, delivery_address, status, estimated_delivery_time, delivery_fee)
    VALUES
        (order1_id, user1_id, 3450.00, 'Flat 301, Green Park Apartments, Sector 18, Noida, UP - 201301', 'confirmed', 
         '2024-12-18 18:00:00+05:30', 50.00);

    -- Create order items
    INSERT INTO public.order_items (order_id, product_name, product_category, quantity, unit_price, total_price, product_image_url)
    VALUES
        (order1_id, 'Royal Canin Golden Retriever Adult Dry Food - 12kg', 'food', 1, 2800.00, 2800.00, 'https://images.unsplash.com/photo-1589924691995-400dc9ecc119?w=300'),
        (order1_id, 'KONG Classic Dog Toy - Large', 'toys', 2, 450.00, 900.00, 'https://images.unsplash.com/photo-1601758228041-f3b2795255f1?w=300'),
        (order1_id, 'Pedigree DentaStix Daily Dental Chews', 'accessories', 1, 320.00, 320.00, 'https://images.unsplash.com/photo-1583337130417-3346a1be7dee?w=300');

    -- Create pet-friendly venues
    INSERT INTO public.pet_friendly_venues (id, name, address, city, venue_type, rating, pet_amenities, contact_number, opening_hours, website_url, image_url)
    VALUES
        (venue1_id, 'The Bark Cafe', 'Shop 12, DLF Mall of India, Sector 18, Noida, UP', 'Delhi', 'cafe', 4.5, 
         ARRAY['pet_menu', 'water_bowls', 'pet_area', 'outdoor_seating'], '+91-9876501234', '9:00 AM - 11:00 PM', 
         'https://thebarkcafe.com', 'https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=400'),
        (venue2_id, 'Pawsome Gardens Restaurant', 'Plot 45, Cyber Hub, Gurgaon, Haryana', 'Delhi', 'restaurant', 4.2,
         ARRAY['pet_menu', 'water_bowls', 'pet_play_area', 'pet_treats'], '+91-9123407890', '11:00 AM - 12:00 AM',
         'https://pawsomegardens.in', 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=400');

    -- Create blog posts
    INSERT INTO public.blog_posts (author_id, title, content, post_type, tags, image_urls, likes_count)
    VALUES
        (user1_id, 'Best Vet Clinic in Noida - My Experience', 
         'I recently visited Dr. Mehta Animal Hospital in Sector 62 for Luna annual checkup. The staff was incredibly professional and caring. Dr. Priya took time to explain everything about Luna health status and provided detailed vaccination schedule. The clinic is clean, well-equipped, and pet-friendly. Highly recommended for all pet parents in NCR!', 
         'clinic_review', ARRAY['vet_review', 'noida', 'healthcare'], 
         ARRAY['https://images.unsplash.com/photo-1576201836106-db1758fd1c97?w=400'], 15),
        (user2_id, 'Pet-Friendly Cafes in Delhi NCR - A Complete Guide',
         'As a dog parent, finding places where Max and I can spend quality time together has been challenging. After visiting numerous cafes across Delhi NCR, I have compiled this comprehensive guide. The Bark Cafe in Noida tops my list with their special pet menu and dedicated play area. They even provide complimentary water bowls and treats! The ambiance is perfect for weekend brunches with your furry friends.',
         'cafe_review', ARRAY['cafe_review', 'delhi', 'pet_friendly', 'weekend'],
         ARRAY['https://images.unsplash.com/photo-1554118811-1e0d58224f24?w=400', 'https://images.unsplash.com/photo-1517248135467-4c7edcad34c4?w=400'], 23);

EXCEPTION
    WHEN unique_violation THEN
        RAISE NOTICE 'Some records already exist, skipping duplicates';
    WHEN foreign_key_violation THEN
        RAISE NOTICE 'Foreign key constraint error: %', SQLERRM;
    WHEN OTHERS THEN
        RAISE NOTICE 'Error in mock data creation: %', SQLERRM;
END $$;