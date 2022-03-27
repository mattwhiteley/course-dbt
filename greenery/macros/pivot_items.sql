{% macro pivot_items (column_name, item_list) %}
    {% for item in item_list %}
        SUM (CASE WHEN {{column_name}}='{{item}}' THEN 1 ELSE 0 END) AS {{item}}_count,
    {% endfor %}
{% endmacro %}