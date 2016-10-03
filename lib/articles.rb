module Larry
  module Articles
    def articles
      blk = -> {
        result = {}
        @items.each do |item|
          if item.identifier.to_s =~ %r[^/articles/(?:[^/]+/)*(\h{8}-\h{4}-\h{4}-\h{4}-\h{12})\.adoc$]
            result[$1] = item unless item[:draft]
          end
        end
        result
      }
      if @items.frozen?
        @articles ||= blk.call
      else
        blk.call
      end
    end

    def article_titles
      blk = -> {
        articles.map{|uuid, item|
          [uuid, item[:title]]
        }.to_h
      }
      if @items.frozen?
        @article_titles ||= blk.call
      else
        blk.call
      end
    end

    def link_to_article(uuid, attributes = {})
      articleitem = articles[uuid]
      link_to h(articleitem[:title]), articleitem.path, attributes
    end
  end
end

include Larry::Articles
