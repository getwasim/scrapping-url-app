class Page < ActiveRecord::Base
  serialize :h1, Array
  serialize :h2, Array
  serialize :h3, Array
  serialize :links, Array

  alias_attribute :link, :links
end