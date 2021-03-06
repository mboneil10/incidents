# frozen_string_literal: true

module ApplicationHelper
  def a11y_date_labels(tag_id)
    a11y_rails_native_select_labels(tag_id, %w[Year Month Day])
  end

  def a11y_datetime_labels(tag_id)
    a11y_rails_native_select_labels(tag_id, %w[Year Month Day Hour Minute])
  end

  def yes_no(value)
    if value == true
      'Yes'
    elsif value == false
      'No'
    end
  end

  def yes_no_image(value)
    if value == true
      content_tag :span, nil, class: 'glyphicon glyphicon-ok'
    elsif value == false
      content_tag :span, nil, class: 'glyphicon glyphicon-remove'
    end
  end

  private

  def a11y_rails_native_select_labels(tag_id, fields)
    fields.map.with_index 1 do |name, index|
      content_tag :label, nil, class: 'a11y-read', for: tag_id + "_#{index}i" do
        name
      end
    end
  end
end
