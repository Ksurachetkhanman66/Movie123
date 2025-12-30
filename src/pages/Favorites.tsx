import { useState, useEffect } from 'react';
import { Link, Navigate } from 'react-router-dom';
import { Heart, Play, Star, ArrowLeft, Trash2 } from 'lucide-react';
import { supabase } from '@/integrations/supabase/client';
import { useAuth } from '@/hooks/useAuth';
import { Button } from '@/components/ui/button';
import { Badge } from '@/components/ui/badge';
import { Skeleton } from '@/components/ui/skeleton';
import { useToast } from '@/hooks/use-toast';

interface Drama {
  id: string;
  title: string;
  title_en: string | null;
  poster_url: string;
  description: string | null;
  episodes: number;
  category: string[];
  section: string;
  view_count: number;
  rating: number;
  year: number | null;
  is_featured: boolean;
}

interface Favorite {
  id: string;
  drama_id: string;
  created_at: string;
  dramas: Drama;
}

const Favorites = () => {
  const { user, loading: authLoading } = useAuth();
  const { toast } = useToast();
  const [favorites, setFavorites] = useState<Favorite[]>([]);
  const [loading, setLoading] = useState(true);

  useEffect(() => {
    if (user) {
      fetchFavorites();
    }
  }, [user]);

  const fetchFavorites = async () => {
    try {
      setLoading(true);
      const { data, error } = await supabase.functions.invoke('favorites', {
        body: { action: 'LIST' }
      });
      
      if (error) throw error;
      
      setFavorites(data?.data || []);
    } catch (err) {
      console.error('Error fetching favorites:', err);
      toast({
        variant: "destructive",
        title: "เกิดข้อผิดพลาด",
        description: "ไม่สามารถโหลดรายการโปรดได้"
      });
    } finally {
      setLoading(false);
    }
  };

  const removeFavorite = async (dramaId: string) => {
    try {
      const { error } = await supabase.functions.invoke('favorites', {
        body: { action: 'REMOVE', drama_id: dramaId }
      });

      if (error) throw new Error('Failed to remove favorite');

      setFavorites(prev => prev.filter(f => f.drama_id !== dramaId));
      toast({
        title: "ลบออกจากรายการโปรด",
        description: "ลบละครออกจากรายการโปรดแล้ว"
      });
    } catch (err) {
      console.error('Error removing favorite:', err);
      toast({
        variant: "destructive",
        title: "เกิดข้อผิดพลาด",
        description: "ไม่สามารถลบออกจากรายการโปรดได้"
      });
    }
  };

  // Redirect to auth if not logged in
  if (!authLoading && !user) {
    return <Navigate to="/auth" replace />;
  }

  const DramaCard = ({ favorite }: { favorite: Favorite }) => {
    const drama = favorite.dramas;
    return (
      <div className="group relative">
        <Link to={`/drama/${drama.id}`} className="block cursor-pointer transition-all duration-300 hover:scale-105">
          <div className="relative aspect-[2/3] overflow-hidden rounded-lg">
            <img
              src={drama.poster_url}
              alt={drama.title}
              className="h-full w-full object-cover transition-transform duration-300 group-hover:scale-110"
            />
            <div className="absolute inset-0 bg-gradient-to-t from-black/80 via-transparent to-transparent opacity-0 group-hover:opacity-100 transition-opacity duration-300" />
            <div className="absolute bottom-2 left-2 right-2">
              <Badge variant="secondary" className="bg-primary/90 text-primary-foreground text-xs">
                {drama.episodes} ตอน
              </Badge>
            </div>
            <div className="absolute top-2 right-2 opacity-0 group-hover:opacity-100 transition-opacity">
              <div className="bg-black/60 backdrop-blur-sm rounded-full p-2">
                <Play className="h-4 w-4 text-white fill-white" />
              </div>
            </div>
          </div>
          <div className="mt-3 space-y-1">
            <h3 className="font-semibold text-sm text-foreground line-clamp-1 group-hover:text-primary transition-colors">
              {drama.title}
            </h3>
            <div className="flex items-center gap-1 text-xs text-muted-foreground">
              <Star className="h-3 w-3 fill-yellow-400 text-yellow-400" />
              <span>{drama.rating}</span>
            </div>
            <div className="flex flex-wrap gap-1">
              {drama.category?.slice(0, 2).map((cat, idx) => (
                <Badge key={idx} variant="outline" className="text-xs py-0 px-1.5">
                  {cat}
                </Badge>
              ))}
            </div>
          </div>
        </Link>
        <Button
          variant="destructive"
          size="icon"
          className="absolute top-2 left-2 h-8 w-8 opacity-0 group-hover:opacity-100 transition-opacity"
          onClick={(e) => {
            e.preventDefault();
            e.stopPropagation();
            removeFavorite(drama.id);
          }}
        >
          <Trash2 className="h-4 w-4" />
        </Button>
      </div>
    );
  };

  const SkeletonCard = () => (
    <div className="space-y-3">
      <Skeleton className="aspect-[2/3] rounded-lg" />
      <Skeleton className="h-4 w-3/4" />
      <Skeleton className="h-3 w-1/2" />
    </div>
  );

  return (
    <div className="min-h-screen bg-background">
      {/* Header */}
      <header className="sticky top-0 z-50 bg-background/95 backdrop-blur-md border-b border-border">
        <div className="container mx-auto px-4 py-3">
          <div className="flex items-center gap-4">
            <Link to="/">
              <Button variant="ghost" size="icon">
                <ArrowLeft className="h-5 w-5" />
              </Button>
            </Link>
            <div className="flex items-center gap-2">
              <Heart className="h-5 w-5 text-red-500 fill-red-500" />
              <h1 className="text-xl font-bold text-foreground">รายการโปรด</h1>
            </div>
          </div>
        </div>
      </header>

      <main className="container mx-auto px-4 py-8">
        {loading || authLoading ? (
          <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-4">
            {Array(6).fill(0).map((_, idx) => (
              <SkeletonCard key={idx} />
            ))}
          </div>
        ) : favorites.length === 0 ? (
          <div className="text-center py-16">
            <Heart className="h-16 w-16 text-muted-foreground mx-auto mb-4" />
            <h2 className="text-xl font-semibold text-foreground mb-2">ยังไม่มีรายการโปรด</h2>
            <p className="text-muted-foreground mb-6">กดปุ่มหัวใจบนละครที่ชอบเพื่อเพิ่มลงรายการโปรด</p>
            <Link to="/">
              <Button className="bg-gradient-to-r from-red-500 to-pink-500 hover:from-red-600 hover:to-pink-600">
                ค้นหาละคร
              </Button>
            </Link>
          </div>
        ) : (
          <>
            <div className="flex items-center gap-2 mb-6">
              <Badge variant="secondary" className="text-sm">
                {favorites.length} เรื่อง
              </Badge>
            </div>
            <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-4">
              {favorites.map(favorite => (
                <DramaCard key={favorite.id} favorite={favorite} />
              ))}
            </div>
          </>
        )}
      </main>
    </div>
  );
};

export default Favorites;
