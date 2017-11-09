module Filterable
  extend ActiveSupport::Concern

  WORDS_TO_REPLACE = %w(bad_word very_bad_word)

  included do
    before_save :filter_text
  end

  private

  def filter_text
    body.gsub!(Regexp.union(WORDS_TO_REPLACE), '***')
  end
end