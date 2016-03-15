class UpdateNamespaceTypes < ActiveRecord::Migration
  def up
    execute("UPDATE blocks SET type = 'SoftwareCommunitiesPlugin::SoftwareHighlightsBlock' WHERE type = 'SoftwareHighlightsBlock'")
    execute("UPDATE blocks SET type = 'SoftwareCommunitiesPlugin::SearchCatalogBlock' WHERE type = 'SearchCatalogBlock'")
    execute("UPDATE blocks SET type = 'SoftwareCommunitiesPlugin::DownloadBlock' WHERE type = 'DownloadBlock'")
    execute("UPDATE blocks SET type = 'SoftwareCommunitiesPlugin::StatisticBlock' WHERE type = 'StatisticBlock'")
    execute("UPDATE blocks SET type = 'SoftwareCommunitiesPlugin::RepositoryBlock' WHERE type = 'RepositoryBlock'")
    execute("UPDATE blocks SET type = 'SoftwareCommunitiesPlugin::SoftwareTabDataBlock' WHERE type = 'SoftwareTabDataBlock'")
    execute("UPDATE blocks SET type = 'SoftwareCommunitiesPlugin::SoftwaresBlock' WHERE type = 'SoftwaresBlock'")
    execute("UPDATE blocks SET type = 'SoftwareCommunitiesPlugin::CategoriesAndTagsBlock' WHERE type = 'CategoriesAndTagsBlock'")
    execute("UPDATE blocks SET type = 'SoftwareCommunitiesPlugin::WikiBlock' WHERE type = 'WikiBlock'")
    execute("UPDATE blocks SET type = 'SoftwareCommunitiesPlugin::SoftwareInformationBlock' WHERE type = 'SoftwareInformationBlock'")
    execute("UPDATE blocks SET type = 'SoftwareCommunitiesPlugin::CategoriesSoftwareBlock' WHERE type = 'CategoriesSoftwareBlock'")
    execute("UPDATE tasks SET type = 'SoftwareCommunitiesPlugin::CreateSoftware' WHERE type = 'CreateSoftware'")
  end

  def down
    execute("UPDATE blocks SET type = 'SoftwareHighlightsBlock' WHERE type = 'SoftwareCommunitiesPlugin::SoftwareHighlightsBlock'")
    execute("UPDATE blocks SET type = 'SearchCatalogBlock' WHERE type = 'SoftwareCommunitiesPlugin::SearchCatalogBlock'")
    execute("UPDATE blocks SET type = 'DownloadBlock' WHERE type = 'SoftwareCommunitiesPlugin::DownloadBlock'")
    execute("UPDATE blocks SET type = 'StatisticBlock' WHERE type = 'SoftwareCommunitiesPlugin::StatisticBlock'")
    execute("UPDATE blocks SET type = 'RepositoryBlock' WHERE type = 'SoftwareCommunitiesPlugin::RepositoryBlock'")
    execute("UPDATE blocks SET type = 'SoftwareTabDataBlock' WHERE type = 'SoftwareCommunitiesPlugin::SoftwareTabDataBlock'")
    execute("UPDATE blocks SET type = 'SoftwaresBlock' WHERE type = 'SoftwareCommunitiesPlugin::SoftwaresBlock'")
    execute("UPDATE blocks SET type = 'CategoriesAndTagsBlock' WHERE type = 'SoftwareCommunitiesPlugin::CategoriesAndTagsBlock'")
    execute("UPDATE blocks SET type = 'WikiBlock' WHERE type = 'SoftwareCommunitiesPlugin::WikiBlock'")
    execute("UPDATE blocks SET type = 'SoftwareInformationBlock' WHERE type = 'SoftwareCommunitiesPlugin::SoftwareInformationBlock'")
    execute("UPDATE blocks SET type = 'CategoriesSoftwareBlock' WHERE type = 'SoftwareCommunitiesPlugin::CategoriesSoftwareBlock'")
    execute("UPDATE tasks SET type = 'CreateSoftware' WHERE type = 'SoftwareCommunitiesPlugin::CreateSoftware'")
  end
end
