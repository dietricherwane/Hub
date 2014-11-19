module ApplicationHelper
  def flash_class(level, class_name)
    case level
    when :notice then "#{class_name}notification notice"
    when :success then "#{class_name}notification success"
    when :error then "#{class_name}notification error"
    when :alert then "#{class_name}notification warning"
    end
  end

  def session_flash_class(level)
    flash_class(level, "session_")
  end

  def field_class(my_object, my_field)
    if my_object.errors.blank?
      "form-control"
    else
      if my_object.valid?
        "form-control"
      else
        my_object.errors[my_field].blank? ? "form-control" : "form-control error"
      end
    end
  end

	def go_back()
    link_to('Revenir en arrière', 'javascript:history.go(-1);', :class => 'cancel')
  end

  def flash_messages!
    [:notice, :error, :success, :alert].each do |key|
      if flash[key]
        @key = key
        @message = flash[key]
      end
    end

    messages!
  end

  def error_messages!
    [:error, :alert].each do |key|
      if flash[key]
        @key = key
        @message = flash[key]
      end
    end

    messages!
  end

  def notification_messages!
    [:notice, :success].each do |key|
      if flash[key]
        @key = key
        @message = flash[key]
      end
    end

    messages!
  end

  def messages!
    return "" if @message.blank?

    html = <<-HTML
    <script type = "text/javascript">
      $(document).on('ready page:load', function(){
        $("#button-close").click(function() {
          $(".notification").hide();
        });
      });
    </script>
    <div class="#{flash_class(@key, '')} fade in">
      <p>
        <div id style = "float:right;">
          <a style = "cursor: pointer; text-decoration: none;" id = "button-close">×</a>
        </div>
        <span>
          #{@message}
        </span>
      </p>
    </div>
    HTML

    html.html_safe
  end
end
