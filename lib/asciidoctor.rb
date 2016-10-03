require_relative 'tags'
include Larry::Tags
require_relative 'articles'
include Larry::Articles

module Larry
  module AsciiDoc
    require 'asciidoctor'
    require 'asciidoctor/core_ext'
    require 'asciidoctor/extensions' unless RUBY_ENGINE == 'opal'

    class ArticleUriMacro < ::Asciidoctor::Extensions::InlineMacroProcessor
      use_dsl

      named :article
      name_positional_attributes 'title'

      def process(parent, target, attrs)
        doc = parent.document
        uuid = target
        text = attrs['title'] || (doc.attributes['article_titles'] || {})[uuid]
        #path = "/articles/#{uuid}/index.html"
        path = "/articles/#{uuid}/"
        anchor = (create_anchor parent, text, type: :link, target: path)
        anchor.add_role('article-link')
        anchor.render
      end
    end

    class TagUriMacro < ::Asciidoctor::Extensions::InlineMacroProcessor
      use_dsl

      named :tag
      name_positional_attributes 'title'

      def process(parent, target, attrs)
        doc = parent.document
        uuid = target
        text = attrs['title'] || (doc.attributes['tag_titles'] || {})[uuid]
        #path = "/tags/#{uuid}/index.html"
        path = "/tags/#{uuid}/"
        anchor = (create_anchor parent, text, type: :link, target: path)
        anchor.add_role('tag-link')
        anchor.render
      end
    end

    class AsciiDocFilter < Nanoc::Filter
      identifier :larry_asciidoc
      include Nanoc::Helpers::HTMLEscape

      def run(content, params = {})
        doc = ::Asciidoctor::Document.new(content, params.dup)
        doc.render(params)
      end
    end
  end
end

::Asciidoctor::Extensions.register :uri_schemes do
  inline_macro Larry::AsciiDoc::ArticleUriMacro
  inline_macro Larry::AsciiDoc::TagUriMacro
end

include Larry::AsciiDoc
