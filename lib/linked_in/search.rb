module LinkedIn
  class Search < APIResource
    def search(options={}, type='people')
      options, type = prepare_options(options, type)
      path = "/#{type.to_s}-search"
      get(path, options)
    end

    private ##############################################################

    def prepare_options(options, type)
      options ||= {}
      if options.is_a? String or options.is_a? Array
        kw = options
        options = {keywords: kw}
      end

      if not options[:type].nil?
        type = options.delete(:type)
      end

      return [options, type]
    end
  end
end
