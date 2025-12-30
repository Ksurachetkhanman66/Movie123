import { useEffect, useState } from 'react';
import { useNavigate, Link } from 'react-router-dom';
import { useAuth } from '@/hooks/useAuth';
import { supabase } from '@/integrations/supabase/client';
import { Button } from '@/components/ui/button';
import { Card, CardContent, CardDescription, CardHeader, CardTitle } from '@/components/ui/card';
import { Badge } from '@/components/ui/badge';
import { Input } from '@/components/ui/input';
import { useToast } from '@/hooks/use-toast';
import { Loader2, Home, Package, Search, Filter } from 'lucide-react';

interface Item {
  id: string;
  name: string;
  description: string | null;
  price: number;
  quantity: number;
  category: string | null;
  created_at: string;
}

const Items = () => {
  const { user, loading: authLoading } = useAuth();
  const navigate = useNavigate();
  const { toast } = useToast();
  
  const [items, setItems] = useState<Item[]>([]);
  const [loading, setLoading] = useState(true);
  const [searchTerm, setSearchTerm] = useState('');
  const [selectedCategory, setSelectedCategory] = useState<string | null>(null);
  const [categories, setCategories] = useState<string[]>([]);

  useEffect(() => {
    if (!authLoading && !user) {
      navigate('/auth');
    }
  }, [user, authLoading, navigate]);

  useEffect(() => {
    if (user) {
      fetchItems();
    }
  }, [user, selectedCategory]);

  const fetchItems = async () => {
    setLoading(true);
    try {
      const params: Record<string, string> = {};
      if (selectedCategory) {
        params.category = selectedCategory;
      }

      const queryString = new URLSearchParams(params).toString();
      const url = queryString ? `items?${queryString}` : 'items';
      
      const { data, error } = await supabase.functions.invoke(url, {
        method: 'GET',
      });

      if (error) throw error;

      if (data.success) {
        setItems(data.data || []);
        
        // Extract unique categories
        const uniqueCategories = [...new Set(data.data?.map((item: Item) => item.category).filter(Boolean))] as string[];
        setCategories(uniqueCategories);
      }
    } catch (error: any) {
      console.error('Error fetching items:', error);
      toast({
        title: 'เกิดข้อผิดพลาด',
        description: 'ไม่สามารถโหลดรายการสินค้าได้',
        variant: 'destructive',
      });
    } finally {
      setLoading(false);
    }
  };

  const filteredItems = items.filter(item => 
    item.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
    item.description?.toLowerCase().includes(searchTerm.toLowerCase())
  );

  const formatPrice = (price: number) => {
    return new Intl.NumberFormat('th-TH', {
      style: 'currency',
      currency: 'THB',
    }).format(price);
  };

  if (authLoading) {
    return (
      <div className="min-h-screen flex items-center justify-center bg-background">
        <Loader2 className="h-8 w-8 animate-spin text-primary" />
      </div>
    );
  }

  if (!user) {
    return null;
  }

  return (
    <div className="min-h-screen bg-gradient-to-br from-background via-secondary/20 to-background">
      <header className="border-b border-border/50 bg-background/80 backdrop-blur-sm sticky top-0 z-10">
        <div className="container mx-auto px-4 py-4 flex items-center justify-between">
          <div className="flex items-center gap-4">
            <Package className="h-6 w-6 text-primary" />
            <h1 className="text-xl font-bold text-foreground">รายการสินค้า</h1>
          </div>
          <Link to="/">
            <Button variant="outline" size="sm">
              <Home className="h-4 w-4 mr-2" />
              หน้าหลัก
            </Button>
          </Link>
        </div>
      </header>

      <main className="container mx-auto px-4 py-8">
        {/* Search and Filter */}
        <div className="mb-8 space-y-4">
          <div className="relative max-w-md">
            <Search className="absolute left-3 top-1/2 -translate-y-1/2 h-4 w-4 text-muted-foreground" />
            <Input
              placeholder="ค้นหาสินค้า..."
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
              className="pl-10"
            />
          </div>
          
          <div className="flex items-center gap-2 flex-wrap">
            <Filter className="h-4 w-4 text-muted-foreground" />
            <Button
              variant={selectedCategory === null ? 'default' : 'outline'}
              size="sm"
              onClick={() => setSelectedCategory(null)}
            >
              ทั้งหมด
            </Button>
            {categories.map((category) => (
              <Button
                key={category}
                variant={selectedCategory === category ? 'default' : 'outline'}
                size="sm"
                onClick={() => setSelectedCategory(category)}
              >
                {category}
              </Button>
            ))}
          </div>
        </div>

        {/* Stats */}
        <div className="grid grid-cols-1 md:grid-cols-3 gap-4 mb-8">
          <Card>
            <CardHeader className="pb-2">
              <CardDescription>จำนวนสินค้าทั้งหมด</CardDescription>
              <CardTitle className="text-3xl">{items.length}</CardTitle>
            </CardHeader>
          </Card>
          <Card>
            <CardHeader className="pb-2">
              <CardDescription>หมวดหมู่</CardDescription>
              <CardTitle className="text-3xl">{categories.length}</CardTitle>
            </CardHeader>
          </Card>
          <Card>
            <CardHeader className="pb-2">
              <CardDescription>มูลค่ารวม</CardDescription>
              <CardTitle className="text-3xl">
                {formatPrice(items.reduce((sum, item) => sum + (item.price * item.quantity), 0))}
              </CardTitle>
            </CardHeader>
          </Card>
        </div>

        {/* Items Grid */}
        {loading ? (
          <div className="flex items-center justify-center py-12">
            <Loader2 className="h-8 w-8 animate-spin text-primary" />
          </div>
        ) : filteredItems.length === 0 ? (
          <div className="text-center py-12">
            <Package className="h-12 w-12 text-muted-foreground mx-auto mb-4" />
            <p className="text-muted-foreground">ไม่พบสินค้า</p>
          </div>
        ) : (
          <div className="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6">
            {filteredItems.map((item) => (
              <Card key={item.id} className="hover:shadow-lg transition-shadow">
                <CardHeader>
                  <div className="flex items-start justify-between">
                    <div>
                      <CardTitle className="text-lg">{item.name}</CardTitle>
                      {item.category && (
                        <Badge variant="secondary" className="mt-2">
                          {item.category}
                        </Badge>
                      )}
                    </div>
                    <span className="text-lg font-bold text-primary">
                      {formatPrice(item.price)}
                    </span>
                  </div>
                </CardHeader>
                <CardContent>
                  {item.description && (
                    <p className="text-sm text-muted-foreground mb-4">
                      {item.description}
                    </p>
                  )}
                  <div className="flex items-center justify-between text-sm">
                    <span className="text-muted-foreground">
                      คงเหลือ: <span className="font-medium text-foreground">{item.quantity}</span> ชิ้น
                    </span>
                  </div>
                </CardContent>
              </Card>
            ))}
          </div>
        )}

        {/* API Info */}
        <Card className="mt-12">
          <CardHeader>
            <CardTitle className="text-lg">API Endpoint</CardTitle>
            <CardDescription>
              ข้อมูลสำหรับเรียกใช้ API
            </CardDescription>
          </CardHeader>
          <CardContent className="space-y-4">
            <div className="bg-muted rounded-lg p-4 font-mono text-sm overflow-x-auto">
              <p className="text-muted-foreground mb-2"># ดึงสินค้าทั้งหมด</p>
              <p className="text-foreground">GET /functions/v1/items</p>
              <p className="text-muted-foreground mt-4 mb-2"># ดึงสินค้าตาม ID</p>
              <p className="text-foreground">GET /functions/v1/items?id=&#123;uuid&#125;</p>
              <p className="text-muted-foreground mt-4 mb-2"># ดึงสินค้าตามหมวดหมู่</p>
              <p className="text-foreground">GET /functions/v1/items?category=Electronics</p>
            </div>
          </CardContent>
        </Card>
      </main>
    </div>
  );
};

export default Items;
