module FiveStars
  class Version

    MAJOR = 0 unless defined? FiveStars::Version::MAJOR 
    MINOR = 0 unless defined? FiveStars::Version::MINOR
    PATCH = 1 unless defined? FiveStars::Version::PATCH

    def self.to_s
      [MAJOR, MINOR, PATCH].join('.')
    end

  end
end