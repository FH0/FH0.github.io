---
layout: home
---

{% for category in site.categories %}
        {% if category.first == "编译" %}
                {% assign compile_size = category | last | size %}
        {% endif %}

        {% if category.first == "折腾" %}
                {% assign toss_size = category | last | size %}
        {% endif %}

        {% if category.first == "人生" %}
                {% assign life_size = category | last | size %}
        {% endif %}

{% endfor %}

<h2>分类</h2>
- [编译({{compile_size}})](/category/compile.html)
- [折腾({{toss_size}})](/category/toss.html)
- [人生({{life_size}})](/category/life.html)
