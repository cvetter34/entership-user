module ApplicationHelper

  def check_boxes_for_member_sector(obj, att)
    out = ""

    checked = (@current_member && @current_member.sectors) || []

    Member.ok_sectors.each_with_index do |sector, index|
      cb = check_box_tag(
        "#{obj.underscore}[#{att.underscore}][]",
        sector[1],
        checked.to_a.include?( sector[1] ),
        id: "#{obj.underscore}_#{att.underscore}_#{index}"
      )
      out += content_tag(:div,
        content_tag(:label,
          "#{cb} #{sector[0]}".html_safe,
          for: "#{obj.underscore}_#{att.underscore}_#{index}"
        ),
        class: "checkbox"
      )
    end

    out.html_safe
  end

  def radio_buttons_for_member_sector(checked, obj, att)
    out = ""

    Company.ok_sectors.each do |sector|
      cb = radio_button_tag( "#{obj.underscore}[#{att.underscore}][]", sector[1], (checked == sector[1].to_s) )
      out += content_tag(:div,
        content_tag(:label,
          "#{cb} #{sector[0]}".html_safe,
          for: "#{obj.underscore}_#{att.underscore}"
        ),
        class: "checkbox"
      )
    end

    out.html_safe
  end

  def options_for_member(member = nil)
    members = [ [ "Select a member:", "" ] ] + Member.all.map do |member|
      [ member.name, member.id ]
    end
    member ? options_for_select( members, member.id ) : options_for_select( members )
  end

  def options_for_company_type(company_type = nil)
    company_types = [ [ "Select a type:", "" ] ] + Company.ok_company_types.to_a
    company_type ? options_for_select( company_types, company_type ) : options_for_select( company_types )
  end

  def options_for_company_size(company_size = nil)
    company_sizes = [ [ "Select a size:", "" ] ] + Company.ok_company_sizes.to_a
    company_size ? options_for_select( company_sizes, company_size ) : options_for_select( company_sizes )
  end

  def flash_noty_script_tag
    javascript_tag(
      %{
        $(function() {
          #{ flash_to_noties.compact.join(" ") }
        });
      }.squish
    ) unless flash.empty?
  end

  private

  def get_type(name)
    name.to_sym == :notice ? "success" : "error"
  end

  def get_timeout(name)
    name.to_sym == :notice ? 4000 : 30000
  end

  def errors_to_ul(errors)
    content_tag(:ul,
      errors.to_a.map do |message|
        content_tag( :li, message ) unless message.blank?
      end.compact.join.html_safe
    ) unless errors.empty?
  end

  def get_text(message)
    message.is_a?(ActiveModel::Errors) ? errors_to_ul(message) : message
  end

  def flash_to_noties
    flash.map do |name, message|
      if ["notice", "error"].include?(name) &&
          (message.is_a?(String) || message.is_a?(ActiveModel::Errors))
        get_noty_call get_type(name), get_timeout(name), get_text(message)
      end
    end
  end

  def get_noty_call(type, timeout, text)
    %{
      noty({
        layout: "bottomRight",
        type: "#{type}",
        timeout: "#{timeout.to_s}",
        text: "#{text}"
      });
    }.squish
  end
end
