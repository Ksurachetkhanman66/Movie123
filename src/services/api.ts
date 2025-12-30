// API Client for MySQL Backend
// This replaces Supabase calls when running with local MySQL backend

const API_BASE_URL = import.meta.env.VITE_API_URL || 'http://localhost:3001';

interface ApiResponse<T = unknown> {
  success: boolean;
  data?: T;
  error?: string;
  total?: number;
}

interface User {
  id: string;
  email: string;
}

interface AuthResponse {
  success: boolean;
  user?: User;
  error?: string;
}

// Generic fetch wrapper with credentials for session cookies
async function apiFetch<T>(
  endpoint: string,
  options: RequestInit = {}
): Promise<ApiResponse<T>> {
  try {
    const response = await fetch(`${API_BASE_URL}${endpoint}`, {
      ...options,
      credentials: 'include', // Include session cookies
      headers: {
        'Content-Type': 'application/json',
        ...options.headers,
      },
    });

    const data = await response.json();
    return data;
  } catch (error) {
    console.error(`API Error (${endpoint}):`, error);
    return {
      success: false,
      error: error instanceof Error ? error.message : 'Network error',
    };
  }
}

// Auth API
export const authApi = {
  async signUp(email: string, password: string): Promise<AuthResponse> {
    return apiFetch('/api/auth/signup', {
      method: 'POST',
      body: JSON.stringify({ email, password }),
    });
  },

  async signIn(email: string, password: string): Promise<AuthResponse> {
    return apiFetch('/api/auth/login', {
      method: 'POST',
      body: JSON.stringify({ email, password }),
    });
  },

  async signOut(): Promise<ApiResponse> {
    return apiFetch('/api/auth/logout', {
      method: 'POST',
    });
  },

  async getMe(): Promise<AuthResponse> {
    return apiFetch('/api/auth/me');
  },
};

// Dramas API
export interface Drama {
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

export const dramasApi = {
  async getAll(params?: {
    section?: string;
    category?: string;
    featured?: boolean;
    search?: string;
    limit?: number;
  }): Promise<ApiResponse<Drama[]>> {
    const searchParams = new URLSearchParams();
    if (params?.section) searchParams.set('section', params.section);
    if (params?.category) searchParams.set('category', params.category);
    if (params?.featured) searchParams.set('featured', 'true');
    if (params?.search) searchParams.set('search', params.search);
    if (params?.limit) searchParams.set('limit', params.limit.toString());

    const query = searchParams.toString();
    return apiFetch(`/api/dramas${query ? `?${query}` : ''}`);
  },

  async getById(id: string): Promise<ApiResponse<Drama>> {
    return apiFetch(`/api/dramas/${id}`);
  },

  async getEpisodes(dramaId: string): Promise<ApiResponse<Episode[]>> {
    return apiFetch(`/api/dramas/${dramaId}/episodes`);
  },
};

// Episodes API
export interface Episode {
  id: string;
  drama_id: string;
  episode_number: number;
  title: string;
  description: string | null;
  thumbnail_url: string | null;
  video_url: string | null;
  duration: number;
  is_free: boolean;
  view_count: number;
}

export const episodesApi = {
  async getById(id: string): Promise<ApiResponse<Episode>> {
    return apiFetch(`/api/episodes/${id}`);
  },

  async incrementView(id: string): Promise<ApiResponse> {
    return apiFetch(`/api/episodes/${id}/view`, {
      method: 'POST',
    });
  },
};

// Favorites API
export interface Favorite {
  id: string;
  drama_id: string;
  created_at: string;
  dramas: Drama;
}

export const favoritesApi = {
  async getAll(): Promise<ApiResponse<Favorite[]>> {
    return apiFetch('/api/favorites');
  },

  async check(dramaId: string): Promise<ApiResponse<{ isFavorite: boolean }>> {
    const response = await apiFetch<{ isFavorite: boolean }>(`/api/favorites/check/${dramaId}`);
    return {
      success: response.success,
      data: { isFavorite: response.data?.isFavorite || (response as { isFavorite?: boolean }).isFavorite || false },
      error: response.error,
    };
  },

  async add(dramaId: string): Promise<ApiResponse> {
    return apiFetch('/api/favorites', {
      method: 'POST',
      body: JSON.stringify({ drama_id: dramaId }),
    });
  },

  async remove(dramaId: string): Promise<ApiResponse> {
    return apiFetch(`/api/favorites/${dramaId}`, {
      method: 'DELETE',
    });
  },
};

// Export all APIs
export const api = {
  auth: authApi,
  dramas: dramasApi,
  episodes: episodesApi,
  favorites: favoritesApi,
};

export default api;
