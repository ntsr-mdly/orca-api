# frozen_string_literal: true

module OrcaApi #:nodoc:
  UNDERSCORE_RE1 = /([A-Z]+)([A-Z][a-z])/.freeze
  UNDERSCORE_RE2 = /([a-z\d])([A-Z])/.freeze
  private_constant :UNDERSCORE_RE1, :UNDERSCORE_RE2

  @_cache = {}

  def self.underscore(str)
    @_cache.fetch(str) do
      @_cache[str] = str.gsub(UNDERSCORE_RE1, '\1_\2').gsub(UNDERSCORE_RE2, '\1_\2').downcase
    end
  end

  def self.trim_response(hash)
    hash.map do |k, v|
      case v
      when Hash
        [k, trim_response(v)]
      when Array
        [k, v.reverse_each.drop_while(&:empty?).reverse.map { |e| trim_response(e) }]
      else
        [k, v]
      end
    end.to_h
  end
end
