---
# Feel free to add content and custom Front Matter to this file.
# To modify the layout, see https://jekyllrb.com/docs/themes/#overriding-theme-defaults

layout: home
---

{% for category in site.categories %}
<h2>{{ category | first }}</h2>
<ul class="arc-list">
    {% for post in category.last %}
        <li>{{ post.date | date:"%d/%m/%Y"}}  <a href="{{ post.url }}">{{ post.title }}</a></li>
    {% endfor %}
</ul>
{% endfor %}

