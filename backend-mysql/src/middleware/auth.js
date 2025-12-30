// Authentication Middleware

const requireAuth = (req, res, next) => {
  if (!req.session || !req.session.userId) {
    return res.status(401).json({
      success: false,
      error: 'Unauthorized - Please log in'
    });
  }
  next();
};

const optionalAuth = (req, res, next) => {
  // Just continue, session info will be available if logged in
  next();
};

module.exports = {
  requireAuth,
  optionalAuth
};
