import { useState, useEffect } from 'react';
import { Link } from 'react-router-dom';
import { Search, Play, Star, ChevronRight, User, Menu, X, Heart } from 'lucide-react';
import { supabase } from '@/integrations/supabase/client';
import { useAuth } from '@/hooks/useAuth';
import { Button } from '@/components/ui/button';
import { Input } from '@/components/ui/input';
import { Badge } from '@/components/ui/badge';
import { Skeleton } from '@/components/ui/skeleton';

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

const CATEGORIES = ['โรแมนติก', 'ดราม่า', 'แอคชั่น', 'ย้อนยุค', 'ตลก', 'แฟนตาซี', 'ลึกลับ', 'สยองขวัญ'];

const Home = () => {
  const { user, signOut } = useAuth();
  const [searchQuery, setSearchQuery] = useState('');
  const [selectedCategory, setSelectedCategory] = useState<string | null>(null);
  const [allDramas, setAllDramas] = useState<Drama[]>([]);
  const [featuredDramas, setFeaturedDramas] = useState<Drama[]>([]);
  const [trendingDramas, setTrendingDramas] = useState<Drama[]>([]);
  const [mustSeeDramas, setMustSeeDramas] = useState<Drama[]>([]);
  const [hiddenGemsDramas, setHiddenGemsDramas] = useState<Drama[]>([]);
  const [loading, setLoading] = useState(true);
  const [activeFeatured, setActiveFeatured] = useState(0);

  useEffect(() => {
    fetchDramas();
  }, []);

  const fetchDramas = async () => {
    try {
      setLoading(true);
      
      // Fetch all dramas from edge function
      const { data, error } = await supabase.functions.invoke('dramas');
      
      if (error) throw error;
      
      const dramas: Drama[] = data?.data || [];
      setAllDramas(dramas);
      
      // Categorize dramas
      setFeaturedDramas(dramas.filter(d => d.is_featured).slice(0, 3));
      setTrendingDramas(dramas.filter(d => d.section === 'trending').slice(0, 6));
      setMustSeeDramas(dramas.filter(d => d.section === 'must-see').slice(0, 6));
      setHiddenGemsDramas(dramas.filter(d => d.section === 'hidden-gems').slice(0, 6));
      
    } catch (err) {
      console.error('Error fetching dramas:', err);
    } finally {
      setLoading(false);
    }
  };

  // Filter dramas based on search and category
  const filteredDramas = allDramas.filter(drama => {
    const matchesSearch = searchQuery.trim() === '' || 
      drama.title.toLowerCase().includes(searchQuery.toLowerCase()) ||
      (drama.title_en && drama.title_en.toLowerCase().includes(searchQuery.toLowerCase()));
    
    const matchesCategory = !selectedCategory || 
      (drama.category && drama.category.includes(selectedCategory));
    
    return matchesSearch && matchesCategory;
  });

  const isSearching = searchQuery.trim() !== '' || selectedCategory !== null;

  const handleSignOut = async () => {
    await signOut();
  };

  const DramaCard = ({ drama }: { drama: Drama }) => (
    <Link to={`/drama/${drama.id}`} className="group cursor-pointer transition-all duration-300 hover:scale-105 block">
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
          {drama.category.slice(0, 2).map((cat, idx) => (
            <Badge key={idx} variant="outline" className="text-xs py-0 px-1.5">
              {cat}
            </Badge>
          ))}
        </div>
      </div>
    </Link>
  );

  const SectionHeader = ({ title, showMore = true }: { title: string; showMore?: boolean }) => (
    <div className="flex items-center justify-between mb-6">
      <h2 className="text-xl md:text-2xl font-bold text-foreground">{title}</h2>
      {showMore && (
        <Button variant="ghost" size="sm" className="text-primary hover:text-primary/80">
          เพิ่มเติม <ChevronRight className="h-4 w-4 ml-1" />
        </Button>
      )}
    </div>
  );

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
          <div className="flex items-center justify-between gap-4">
            {/* Logo */}
            <Link to="/" className="flex items-center gap-2">
              <div className="bg-gradient-to-r from-red-500 to-pink-500 rounded-lg p-2">
                <Play className="h-5 w-5 text-white fill-white" />
              </div>
              <span className="text-xl font-bold bg-gradient-to-r from-red-500 to-pink-500 bg-clip-text text-transparent">
                DramaBox
              </span>
            </Link>

            {/* Navigation */}
            <nav className="hidden md:flex items-center gap-6">
              <Link to="/" className="text-foreground font-medium hover:text-primary transition-colors">
                หน้าแรก
              </Link>
              <Link to="/favorites" className="text-muted-foreground hover:text-primary transition-colors flex items-center gap-1">
                <Heart className="h-4 w-4" />
                รายการโปรด
              </Link>
            </nav>

            {/* Search */}
            <div className="hidden md:flex flex-1 max-w-md">
              <div className="relative w-full">
                <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
                <Input
                  type="text"
                  placeholder="ค้นหาละคร..."
                  value={searchQuery}
                  onChange={(e) => setSearchQuery(e.target.value)}
                  className="pl-10 bg-muted/50 border-0 focus-visible:ring-primary"
                />
              </div>
            </div>

            {/* User Actions */}
            <div className="flex items-center gap-2">
              {user ? (
                <Button variant="ghost" size="sm" onClick={handleSignOut} className="hidden md:flex">
                  <User className="h-4 w-4 mr-2" />
                  ออกจากระบบ
                </Button>
              ) : (
                <Link to="/auth">
                  <Button variant="default" size="sm" className="bg-gradient-to-r from-red-500 to-pink-500 hover:from-red-600 hover:to-pink-600">
                    เข้าสู่ระบบ
                  </Button>
                </Link>
              )}
              <Button variant="ghost" size="icon" className="md:hidden">
                <Menu className="h-5 w-5" />
              </Button>
            </div>
          </div>
        </div>
      </header>

      <main className="container mx-auto px-4 py-8">
        {/* Category Filter */}
        <section className="mb-6">
          <div className="flex flex-wrap items-center gap-2">
            <Button
              variant={selectedCategory === null ? "default" : "outline"}
              size="sm"
              onClick={() => setSelectedCategory(null)}
              className={selectedCategory === null ? "bg-gradient-to-r from-red-500 to-pink-500 hover:from-red-600 hover:to-pink-600" : ""}
            >
              ทั้งหมด
            </Button>
            {CATEGORIES.map(category => (
              <Button
                key={category}
                variant={selectedCategory === category ? "default" : "outline"}
                size="sm"
                onClick={() => setSelectedCategory(selectedCategory === category ? null : category)}
                className={selectedCategory === category ? "bg-gradient-to-r from-red-500 to-pink-500 hover:from-red-600 hover:to-pink-600" : ""}
              >
                {category}
              </Button>
            ))}
          </div>
        </section>

        {/* Search Results or Home Content */}
        {isSearching ? (
          <section className="mb-12">
            <div className="flex items-center justify-between mb-6">
              <div className="flex items-center gap-3">
                <h2 className="text-xl md:text-2xl font-bold text-foreground">
                  ผลการค้นหา
                </h2>
                <Badge variant="secondary" className="text-sm">
                  {filteredDramas.length} เรื่อง
                </Badge>
              </div>
              <Button
                variant="ghost"
                size="sm"
                onClick={() => {
                  setSearchQuery('');
                  setSelectedCategory(null);
                }}
                className="text-muted-foreground hover:text-foreground"
              >
                <X className="h-4 w-4 mr-1" />
                ล้างการค้นหา
              </Button>
            </div>

            {filteredDramas.length === 0 ? (
              <div className="text-center py-16">
                <div className="text-6xl mb-4">🔍</div>
                <h3 className="text-xl font-semibold text-foreground mb-2">ไม่พบละครที่ค้นหา</h3>
                <p className="text-muted-foreground">ลองค้นหาด้วยคำอื่น หรือเลือกหมวดหมู่อื่น</p>
              </div>
            ) : (
              <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-4">
                {filteredDramas.map(drama => (
                  <DramaCard key={drama.id} drama={drama} />
                ))}
              </div>
            )}
          </section>
        ) : (
          <>
        {/* Hero / Featured Section */}
        {!loading && featuredDramas.length > 0 && (
          <section className="mb-12">
            <div className="grid grid-cols-1 lg:grid-cols-3 gap-6">
              {/* Main Featured */}
              <div className="lg:col-span-2 relative group cursor-pointer overflow-hidden rounded-2xl">
                <div className="aspect-[16/9] lg:aspect-[21/9]">
                  <img
                    src={featuredDramas[activeFeatured]?.poster_url}
                    alt={featuredDramas[activeFeatured]?.title}
                    className="h-full w-full object-cover transition-transform duration-500 group-hover:scale-105"
                  />
                </div>
                <div className="absolute inset-0 bg-gradient-to-t from-black via-black/40 to-transparent" />
                <div className="absolute bottom-0 left-0 right-0 p-6 md:p-8">
                  <Badge className="bg-red-500 text-white mb-3">
                    แนะนำ
                  </Badge>
                  <h1 className="text-2xl md:text-4xl font-bold text-white mb-2">
                    {featuredDramas[activeFeatured]?.title}
                  </h1>
                  <p className="text-white/80 text-sm md:text-base mb-4 line-clamp-2 max-w-xl">
                    {featuredDramas[activeFeatured]?.description}
                  </p>
                  <div className="flex items-center gap-4">
                    <Button className="bg-gradient-to-r from-red-500 to-pink-500 hover:from-red-600 hover:to-pink-600">
                      <Play className="h-4 w-4 mr-2 fill-white" />
                      ดูเลย
                    </Button>
                    <div className="flex items-center gap-2 text-white/80">
                      <Star className="h-4 w-4 fill-yellow-400 text-yellow-400" />
                      <span>{featuredDramas[activeFeatured]?.rating}</span>
                      <span className="mx-2">•</span>
                      <span>{featuredDramas[activeFeatured]?.episodes} ตอน</span>
                    </div>
                  </div>
                </div>
                {/* Featured Navigation Dots */}
                <div className="absolute bottom-4 right-4 flex gap-2">
                  {featuredDramas.map((_, idx) => (
                    <button
                      key={idx}
                      onClick={() => setActiveFeatured(idx)}
                      className={`w-2 h-2 rounded-full transition-all ${
                        idx === activeFeatured ? 'bg-white w-6' : 'bg-white/50'
                      }`}
                    />
                  ))}
                </div>
              </div>

              {/* Side Featured */}
              <div className="hidden lg:flex flex-col gap-4">
                {featuredDramas.slice(0, 2).map((drama, idx) => (
                  <div
                    key={drama.id}
                    onClick={() => setActiveFeatured(idx)}
                    className={`flex gap-4 p-3 rounded-xl cursor-pointer transition-all ${
                      idx === activeFeatured 
                        ? 'bg-primary/10 border border-primary/30' 
                        : 'bg-muted/50 hover:bg-muted'
                    }`}
                  >
                    <img
                      src={drama.poster_url}
                      alt={drama.title}
                      className="w-20 h-28 object-cover rounded-lg"
                    />
                    <div className="flex-1 flex flex-col justify-center">
                      <h3 className="font-semibold text-foreground line-clamp-1">{drama.title}</h3>
                      <p className="text-xs text-muted-foreground line-clamp-2 mt-1">
                        {drama.description}
                      </p>
                      <div className="flex items-center gap-2 mt-2">
                        <Badge variant="outline" className="text-xs">
                          {drama.episodes} ตอน
                        </Badge>
                        {drama.category[0] && (
                          <Badge variant="secondary" className="text-xs">
                            {drama.category[0]}
                          </Badge>
                        )}
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          </section>
        )}

        {/* Trending Section */}
        <section className="mb-12">
          <SectionHeader title="ละครยอดนิยม 🔥" />
          {loading ? (
            <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-4">
              {Array(6).fill(0).map((_, idx) => (
                <SkeletonCard key={idx} />
              ))}
            </div>
          ) : (
            <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-4">
              {trendingDramas.map(drama => (
                <DramaCard key={drama.id} drama={drama} />
              ))}
            </div>
          )}
        </section>

        {/* Must See Section */}
        <section className="mb-12">
          <SectionHeader title="ละครต้องดู ⭐" />
          {loading ? (
            <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-4">
              {Array(6).fill(0).map((_, idx) => (
                <SkeletonCard key={idx} />
              ))}
            </div>
          ) : (
            <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-4">
              {mustSeeDramas.map(drama => (
                <DramaCard key={drama.id} drama={drama} />
              ))}
            </div>
          )}
        </section>

        {/* Hidden Gems Section */}
        <section className="mb-12">
          <SectionHeader title="ละครน่าค้นพบ 💎" />
          {loading ? (
            <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-4">
              {Array(6).fill(0).map((_, idx) => (
                <SkeletonCard key={idx} />
              ))}
            </div>
          ) : (
            <div className="grid grid-cols-2 sm:grid-cols-3 md:grid-cols-4 lg:grid-cols-6 gap-4">
              {hiddenGemsDramas.map(drama => (
                <DramaCard key={drama.id} drama={drama} />
              ))}
            </div>
          )}
        </section>
        </>
        )}
      </main>

      {/* Footer */}
      <footer className="bg-muted/30 border-t border-border py-8">
        <div className="container mx-auto px-4">
          <div className="flex flex-col md:flex-row items-center justify-between gap-4">
            <div className="flex items-center gap-2">
              <div className="bg-gradient-to-r from-red-500 to-pink-500 rounded-lg p-2">
                <Play className="h-4 w-4 text-white fill-white" />
              </div>
              <span className="font-bold text-foreground">DramaBox</span>
            </div>
            <p className="text-sm text-muted-foreground">
              © 2024 DramaBox. สงวนลิขสิทธิ์ทั้งหมด
            </p>
          </div>
        </div>
      </footer>
    </div>
  );
};

export default Home;
