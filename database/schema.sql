-- =====================================================
-- DramaBox Database Schema
-- Created: 2024-12-30
-- =====================================================

-- =====================================================
-- 1. TABLES
-- =====================================================

-- Dramas Table
CREATE TABLE IF NOT EXISTS public.dramas (
    id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    title TEXT NOT NULL,
    title_en TEXT,
    description TEXT,
    poster_url TEXT NOT NULL,
    episodes INTEGER DEFAULT 1,
    category TEXT[] DEFAULT '{}',
    section TEXT DEFAULT 'general',
    view_count INTEGER DEFAULT 0,
    rating NUMERIC DEFAULT 0,
    year INTEGER,
    is_featured BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Episodes Table
CREATE TABLE IF NOT EXISTS public.episodes (
    id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    drama_id UUID NOT NULL REFERENCES public.dramas(id) ON DELETE CASCADE,
    episode_number INTEGER NOT NULL,
    title TEXT NOT NULL,
    description TEXT,
    video_url TEXT,
    thumbnail_url TEXT,
    duration INTEGER DEFAULT 0,
    is_free BOOLEAN DEFAULT false,
    view_count INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- Favorites Table
CREATE TABLE IF NOT EXISTS public.favorites (
    id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID NOT NULL,
    drama_id UUID NOT NULL REFERENCES public.dramas(id) ON DELETE CASCADE,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    UNIQUE(user_id, drama_id)
);

-- Items Table (สำหรับ demo)
CREATE TABLE IF NOT EXISTS public.items (
    id UUID NOT NULL DEFAULT gen_random_uuid() PRIMARY KEY,
    name TEXT NOT NULL,
    description TEXT,
    price NUMERIC NOT NULL DEFAULT 0,
    quantity INTEGER NOT NULL DEFAULT 0,
    category TEXT,
    created_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now(),
    updated_at TIMESTAMP WITH TIME ZONE NOT NULL DEFAULT now()
);

-- =====================================================
-- 2. FUNCTIONS
-- =====================================================

-- Function to update updated_at column
CREATE OR REPLACE FUNCTION public.update_updated_at_column()
RETURNS TRIGGER
LANGUAGE plpgsql
SET search_path = 'public'
AS $$
BEGIN
    NEW.updated_at = now();
    RETURN NEW;
END;
$$;

-- =====================================================
-- 3. TRIGGERS
-- =====================================================

-- Trigger for dramas table
DROP TRIGGER IF EXISTS update_dramas_updated_at ON public.dramas;
CREATE TRIGGER update_dramas_updated_at
    BEFORE UPDATE ON public.dramas
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at_column();

-- Trigger for episodes table
DROP TRIGGER IF EXISTS update_episodes_updated_at ON public.episodes;
CREATE TRIGGER update_episodes_updated_at
    BEFORE UPDATE ON public.episodes
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at_column();

-- Trigger for items table
DROP TRIGGER IF EXISTS update_items_updated_at ON public.items;
CREATE TRIGGER update_items_updated_at
    BEFORE UPDATE ON public.items
    FOR EACH ROW
    EXECUTE FUNCTION public.update_updated_at_column();

-- =====================================================
-- 4. ROW LEVEL SECURITY (RLS)
-- =====================================================

-- Enable RLS on all tables
ALTER TABLE public.dramas ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.episodes ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.favorites ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.items ENABLE ROW LEVEL SECURITY;

-- Dramas Policies
CREATE POLICY "Anyone can view dramas" ON public.dramas
    FOR SELECT USING (true);

CREATE POLICY "Authenticated users can insert dramas" ON public.dramas
    FOR INSERT WITH CHECK (auth.uid() IS NOT NULL);

CREATE POLICY "Authenticated users can update dramas" ON public.dramas
    FOR UPDATE USING (auth.uid() IS NOT NULL);

CREATE POLICY "Authenticated users can delete dramas" ON public.dramas
    FOR DELETE USING (auth.uid() IS NOT NULL);

-- Episodes Policies
CREATE POLICY "Anyone can view episodes" ON public.episodes
    FOR SELECT USING (true);

CREATE POLICY "Authenticated users can insert episodes" ON public.episodes
    FOR INSERT WITH CHECK (auth.uid() IS NOT NULL);

CREATE POLICY "Authenticated users can update episodes" ON public.episodes
    FOR UPDATE USING (auth.uid() IS NOT NULL);

CREATE POLICY "Authenticated users can delete episodes" ON public.episodes
    FOR DELETE USING (auth.uid() IS NOT NULL);

-- Favorites Policies
CREATE POLICY "Users can view their own favorites" ON public.favorites
    FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can add their own favorites" ON public.favorites
    FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can delete their own favorites" ON public.favorites
    FOR DELETE USING (auth.uid() = user_id);

-- Items Policies
CREATE POLICY "Anyone can view items" ON public.items
    FOR SELECT USING (true);

CREATE POLICY "Authenticated users can insert items" ON public.items
    FOR INSERT WITH CHECK (true);

CREATE POLICY "Authenticated users can update items" ON public.items
    FOR UPDATE USING (true);

CREATE POLICY "Authenticated users can delete items" ON public.items
    FOR DELETE USING (true);

-- =====================================================
-- 5. INDEXES
-- =====================================================

CREATE INDEX IF NOT EXISTS idx_dramas_section ON public.dramas(section);
CREATE INDEX IF NOT EXISTS idx_dramas_is_featured ON public.dramas(is_featured);
CREATE INDEX IF NOT EXISTS idx_dramas_view_count ON public.dramas(view_count DESC);
CREATE INDEX IF NOT EXISTS idx_episodes_drama_id ON public.episodes(drama_id);
CREATE INDEX IF NOT EXISTS idx_episodes_episode_number ON public.episodes(drama_id, episode_number);
CREATE INDEX IF NOT EXISTS idx_favorites_user_id ON public.favorites(user_id);
CREATE INDEX IF NOT EXISTS idx_favorites_drama_id ON public.favorites(drama_id);
