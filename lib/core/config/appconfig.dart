class AppConfig {
  static const appName = "avatar_flow";
  static const baseUrl = "https://avatar_flow-backend.vercel.app/api";

  // Auth Endpoints
  static const String login = "/auth/login";
  static const String register = "/auth/register";
  static const String recoverPassword = "/auth/recover";
  static const String socialLogin = "/auth/social-login";

  // Products Endpoints
  static const String products = "/products";
  static const String productSearch = "/products/search";
  static const String newArrivals = "/products/new-arrivals";
  static const String popularProducts = "/products/popular";
  static const String trendingProducts = "/products/trending";
  static const String featuredProducts = "/products/featured";
  static const String predictiveSearch = "/products/predictive-search";
  static String productDetail(String handle) => "/products/$handle";
  static String productRecommendations(String id) =>
      "/products/$id/recommendations";
  static String productReviews(String handle) => "/reviews/product/$handle";
  static const String myReviews = "/reviews/my";
  static const String addReview = "/reviews/add";
  static String productAvailability(String handle) =>
      "/products/$handle/availability";
  static const String nearestLocations = "/products/locations/nearest";

  // Collections Endpoints
  static const String collections = "/collections";
  static String collectionDetail(String handle) => "/collections/$handle";
  static const String featuredHighlight = "/collections/featured-highlight";

  // Cart Endpoints
  static const String cart = "/cart";
  static String addToCart(String cartId) => "/cart/$cartId/add";
  static String getCart(String cartId) => "/cart/$cartId";
  static String removeFromCart(String cartId) => "/cart/$cartId/remove";
  static String updateCart(String cartId) => "/cart/$cartId/update";
  static String updateCartDiscounts(String cartId) => "/cart/$cartId/discounts";
  static String updateCartBuyerIdentity(String cartId) =>
      "/cart/$cartId/buyer-identity";
  static String getCheckoutUrl(String cartId) => "/cart/$cartId/checkout";

  // User Profile Endpoints (Require Auth)
  static const String userProfile = "/user/profile";
  static const String userAddresses = "/user/addresses";
  static String userAddressDetail(String id) => "/user/addresses/$id";

  // Orders Endpoints (Require Auth)
  static const String orders = "/orders";
  static String orderDetail(String id) => "/orders/$id";

  // Wishlist Endpoints (Require Auth)
  static const String wishlist = "/wishlist";
  static const String addToWishlist = "/wishlist/add";
  static const String removeFromWishlist = "/wishlist/remove";

  // Notifications Endpoints (Require Auth)
  static const String notifications = "/notifications";
  static const String sendNotification = "/notifications/send";
  static const String readNotification = "/notifications/read";
  static const String clearNotifications = "/notifications/clear";
  static const String registerToken = "/notifications/register-token";

  // AI Chat Endpoint
  static const String chat = "/chat";
  static const String chatSend = "/chat/send";
  static const String chatHistory = "/chat/history";

  // AI Features
  static const String aiTryOn = "/ai/try-on";
  static const String visualSearch = "/ai-features/visual-search";
  static String productInsights(String handle) =>
      "/ai-features/products/$handle/insights";

  // Shop Policies Endpoint
  static const String shopPolicies = "/shop/policies";

  // UI Elements Endpoint
  static const String banners = "/ui/banners";

  // Content Endpoints
  static const String blogs = "/content/blogs";
  static String blogArticles(String handle) =>
      "/content/blogs/$handle/articles";
  static String articleDetail(String blogHandle, String articleHandle) =>
      "/content/blogs/$blogHandle/articles/$articleHandle";
  static const String pages = "/content/pages";
  static String pageDetail(String handle) => "/content/pages/$handle";
}
