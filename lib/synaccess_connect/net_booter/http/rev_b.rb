module NetBooter

  module Http

    class RevB < HttpConnection

      def toggle_relay(outlet)
        get_request("/cmd.cgi?rly=#{outlet - 1}")
      end

      def statuses
        resp   = get_request('/status.xml')

        doc    = Nokogiri::XML(resp.body)
        nodes  = doc.xpath('/response/*')

        status = {}
        nodes.each do |node|
          if node.name.match(/^rly(\d+)$/)
            status[$1.to_i + 1] = node.content == '1' ? true : false
          end
        end
        status
      end

    end

  end

end
