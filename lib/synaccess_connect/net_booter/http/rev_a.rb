module NetBooter

  module Http

    class RevA < HttpConnection
      # So here's the deal... When you hit the switch page (pwrSw1.cgi) nothing happens.
      # It's only when hitting the status page AFTER visiting a swith page that
      # the relay is toggled.
      def toggle_relay(outlet)
        get_request("/pwrSw#{outlet}.cgi")
        get_request("/synOpStatus.shtml")
      end

      def statuses
        resp   = get_request('/synOpStatus.shtml')

        doc    = Nokogiri::HTML(resp.body)
        nodes  = doc.xpath('//img')
        status = {}

        nodes.each do |node|
          if node.values[0].match(/^led(off|on).gif$/)
            status[node.parent.parent.xpath('th').first.content.to_i] = $1 == 'on' ? true : false
          end
        end
        status
      end
    end

  end

end
