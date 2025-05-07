{% test expect_column_values_to_match_regex_list_regexp_like(model, column_name, regex_list) %}

{% set row_condition = kwargs.get('row_condition', 'true') %}

with validation_errors as (
    select *
    from {{ model }}
    where {{ row_condition }}
    and not (
        {% for pattern in regex_list %}
            REGEXP_LIKE({{ column_name }}, '{{ pattern }}') {% if not loop.last %} OR {% endif %}
        {% endfor %}
    )
)

select *
from validation_errors

{% endtest %}
