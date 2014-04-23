module I18n
  class MissingTranslationExceptionHandler < ExceptionHandler
    def call(exception, locale, key, options)
      if exception.is_a?(MissingTranslation)
        key
      else
        super
      end
    end
  end
end

I18n.exception_handler = I18n::MissingTranslationExceptionHandler.new
