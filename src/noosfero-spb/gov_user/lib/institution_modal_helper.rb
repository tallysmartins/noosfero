class InstitutionModalHelper
  extend(
    ActionView::Helpers::FormOptionsHelper, # content_tag
    ActionView::Helpers::FormTagHelper, # button_tag
    ActionView::Helpers::UrlHelper, # link_to
    ActionView::Context # content_tag do end
  )

  def self.modal_button link_text=_("Create new institution"), display="block"
    # HTML Sample in: http://getbootstrap.com/javascript/#modals-examples
    content_tag :div, :id=>"institution_modal_container", :style=>"display: #{display}" do
      link = link_to(
        link_text,
        "javascript: void(0)",
        {:class=>"button with-text", :data=>{:toggle=>"modal", :target=>"#institution_modal"}, :id=>"create_institution_link"}
      )

      link.concat modal
    end
  end

  private

  def self.modal
    options = {
      :id=>"institution_modal",
      :role=>"dialog",
      :class=>"modal fade"
    }

    content_tag :div, options do
      modal_dialog
    end
  end

  def self.modal_dialog
    content_tag :div, :class=>"modal-dialog", :role=>"document" do
      modal_content
    end
  end

  def self.modal_content
    content_tag :div, :class=>"modal-content" do
      #modal_header.concat(modal_body.concat(modal_footer))
      modal_header.concat(modal_body)
    end
  end

  def self.modal_header
    content_tag :div, :class=>"modal-header" do
      button = button_tag :type=>"button", :data=>{:dismiss=>"modal"}, :class=>"close" do
        content_tag :span, "&times;"
      end

      h4 = content_tag :h4, _("New Institution"), :class=>"modal-title"

      button.concat h4
    end
  end

  def self.modal_body
    content_tag :div, "", :id=>"institution_modal_body", :class=>"modal-body"
  end

  #def self.modal_footer
  #  content_tag :div, {:class=>"modal-footer"} do
  #    close = button_tag _("Close"), :type=>"button", :class=>"button with-text"
  #    save = button_tag _("Save changes"), :type=>"button", :class=>"button with-text"
  #
  #    close.concat save
  #  end
  #end
end

