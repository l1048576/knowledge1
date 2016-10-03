#require_relative 'articles'

module Larry
  module Tags
    def tags
      blk = -> {
        result = {}
        @items.each do |item|
          if item.identifier.to_s =~ %r[/tags/(?:[^/]+/)*(\h{8}-\h{4}-\h{4}-\h{4}-\h{12})\.adoc]
            result[$1] = item unless item[:draft]
          end
        end
        result
      }
      if @items.frozen?
        @tags ||= blk.call
      else
        blk.call
      end
    end

    def tag_titles
      blk = -> {
        tags.map{|uuid, item|
          [uuid, item[:title]]
        }.to_h
      }
      if @items.frozen?
        @tag_titles ||= blk.call
      else
        blk.call
      end
    end

    def tag_dag
      result = {}
      blk = -> {
        tags.each do |tag_uuid, tag_item|
          tag_result = result[tag_uuid] ||= {}
          tag_result[:parents] = (item[:parents] || []).map{|parent_uuid|
            [parent_uuid, tags[parent_uuid]]
          }.to_h
          (item[:parents] || []).each do |parent_uuid|
            parent_result = result[parent_uuid] ||= {}
            (parent_result[:children] ||= {})[tag_uuid] = tags[tag_item]
          end
        end
        result
      }
      if @items.frozen?
        @tag_dag ||= blk.call
      else
        blk.call
      end
    end

    def link_to_tag(uuid, attributes = {})
      tagitem = tags[uuid]
      link_to h(tagitem[:title]), tagitem.path, attributes
    end
  end
end

include Larry::Tags
