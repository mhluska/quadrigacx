module QuadrigaCX
  class Error                   < StandardError; end
  class ConfigurationError      < Error; end
  class Unauthorized            < Error; end
  class NotFound                < Error; end
  class ExceedsAvailableBalance < Error; end
  class BelowMinimumOrderValue  < Error; end
  class AboveMaximumOrderValue  < Error; end
end
