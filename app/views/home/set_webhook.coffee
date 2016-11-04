<%if @error.present?%>
$('<li/>').html('<%="ERROR: #{@error.message}" %>').appendTo('ul#messages')
<% else %>
$('<li/>').html('<%= @data %>').appendTo('ul#messages')
<% end %>