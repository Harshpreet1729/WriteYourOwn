from django.urls import path
from app.views import(
    ArticleListView,
    ArticleCreateView,
    ArticleUpdateView,
    ArticleDeleteView
)

urlpatterns = [   # the name is important it has to ve urlpatterns only
    path("",ArticleListView.as_view(),name="home"),
    path("create/",ArticleCreateView.as_view(),name="create_article"),
    path("<int:pk>/update/",ArticleUpdateView.as_view(),name="update_article"), # pk is primarykey
    path("<int:pk>/delete/",ArticleDeleteView.as_view(),name="delete_article")
]
