#!/bin/env ruby
# encoding: utf-8

namespace :templates do
  namespace :create do

    desc "Create new templates of software, intitution, person and community"
    task :all => :environment do
      Rake::Task["templates:create:institution"].invoke
      Rake::Task["templates:create:software"].invoke
      Rake::Task["templates:create:people"].invoke
      Rake::Task["templates:create:community"].invoke
    end

    desc "Create new templates of software"
    task :software => :environment do
      Environment.all.each do |env|
        if env.plugin_enabled?("MpogSoftware") or env.plugin_enabled?("SoftwareCommunitiesPlugin")
          software = Community["software"]

          if software.nil?
            software = Community.create!(:name => "Software", :identifier => "software")
          end

          software.layout_template = "default"
          software.is_template = true

          box1 = software.boxes.where(:position => 1).first
          box1.blocks.destroy_all
          software.save!

          #This box is going to be used for fixed blocks
          box2 = software.boxes.where(:position => 2).first
          box2.blocks.destroy_all
          software.save!

          box3 = software.boxes.where(:position => 3).first
          box3.blocks.destroy_all
          software.save!
          puts "Software successfully created!"

          categories_block = CategoriesAndTagsBlock.new
          categories_block.position = 4
          categories_block.display = "home_page_only"
          categories_block.save!
          box1.blocks << categories_block
          box1.save!
          puts "CategoriesAndTagsBlock successfully added to software!"

          main_block = MainBlock.new
          main_block.position = 3
          main_block.save!
          box1.blocks << main_block
          box1.save!

          download_block = DownloadBlock.new
          download_block.position = 2
          download_info = Hash.new
          download_info[:name] = "Versão  X.Y"
          download_info[:link] = "#"
          download_info[:software_description] = "(Windows X, Ubuntu Y, Debian Z)"
          download_info[:version_news] = "#"
          download_block.downloads << download_info
          download_block.display = "home_page_only"
          download_block.save!
          box1.blocks << download_block
          box1.save!
          puts "DownloadBlock successfully added to software!"

          software_information_block = SoftwareInformationBlock.new
          software_information_block.position = 1
          software_information_block.display = "home_page_only"
          software_information_block.save!
          box1.blocks << software_information_block
          box1.save!
          puts "SoftwareInformation successfully added to software!"

          puts "Software Main Box successfully created!"


          members_block = MembersBlock.new
          members_block.position = 6
          members_block.display = "except_home_page"
          members_block.name = ""
          members_block.address = ""
          members_block.visible_role = ""
          members_block.limit = 6
          members_block.prioritize_profiles_with_image = true
          members_block.show_join_leave_button = false
          members_block.title = "Equipe"

          members_block.save!
          box3.blocks << members_block
          box3.save!

          another_link_list_block = LinkListBlock.new
          another_link_list_block.position = 5
          another_link_list_block.display = "always"
          another_link_list_block.title = "Participe"
          links = [{:icon => "", :name => "Lista de E-mails", :address => "http://beta.softwarepublico.gov.br/archives/thread/", :target => "_self"}, {:icon => "no-icon", :name => "Comunidade", :address => "/profile/{profile}", :target => "_self"}, {:icon => "", :name => "Blog", :address => "/{profile}/blog", :target => "_self"}, {:icon => "", :name => "Convide Amigos", :address => "/profile/{profile}/invite/friends", :target => "_self"}]

          another_link_list_block.save!
          box3.blocks << another_link_list_block
          another_link_list_block.update_attributes(:links => links)
          box3.save!
          puts "LinkListBlock successfully added to software!"


          repository_block = RepositoryBlock.new
          repository_block.position = 4
          repository_block.display = "always"
          repository_block.title = ""

          repository_block.save!
          box3.blocks << repository_block
          box3.save!
          puts "RepositoryBlock successfully added to software!"

          link_list_block = LinkListBlock.new
          link_list_block.position = 3
          link_list_block.display = "always"
          link_list_block.title = "Ajuda"

          link_list_block.save!
          link_list_block.links << {:icon => "no-icon", :name => "Download de Versões", :address => "/{profile}/versoes", :target => "_self"}
          link_list_block.links << {:icon => "", :name => "Pergutas Frequentes", :address => "/{profile}/perguntas-frequentes", :target => "_self"}
          link_list_block.links << {:icon => "no-icon", :name => "README", :address => "/{profile}/versoes-estaveis", :target => "_self"}
          link_list_block.links << {:icon => "", :name => "Como Instalar", :address => "/{profile}/tutorial-de-instalacao", :target => "_self"}
          link_list_block.links << {:icon => "", :name => "Manuais", :address => "/{profile}/manuais-de-usuario", :target => "_self"}
          link_list_block.save!
          box3.blocks << link_list_block
          box3.save!
          puts "LinkListBlock successfully added to software!"

          profile_image_block = ProfileImageBlock.new
          profile_image_block.position = 2
          profile_image_block.display = "except_home_page"
          profile_image_block.show_name = false
          profile_image_block.save!

          box3.blocks << profile_image_block
          box3.save!
          puts "ProfileImageBlock successfully added to software!"

          statistics_block = StatisticsBlock.new
          statistics_block.position = 1
          statistics_block.display = "home_page_only"
          statistics_block.save!
          box3.blocks << statistics_block
          box3.save!
          puts "StatisticsBlock successfully added to software!"
          puts "MembersBlock successfully added to software!"
          puts "Software Box 3 successfully created!"

          generate_article(software, TinyMceArticle, {name: "Perguntas Frequentes", slug: "perguntas-frequentes", published: true, accept_comments: true, notify_comments: true, license_id: 1, body: "<h3 style=\"text-align: justify;\">Pergunta 1</h3>\r\n<ul>\r\n<li>Resposta: Resposta para a pergunta 1.</li>\r\n</ul>\r\n<p> </p>\r\n<h3>Pergunta 2</h3>\r\n<ul>\r\n<li>Resposta: Resposta para a pergunta 2.</li>\r\n</ul>\r\n<p> </p>\r\n<h3 style=\"text-align: justify;\">Pergunta 3</h3>\r\n<ul>\r\n<li style=\"text-align: justify;\">Resposta: Resposta para a pergunta 3.</li>\r\n</ul>"})

          generate_article(software, Folder, {name: "Manuais de Usuário", published: true, accept_comments: false, notify_comments: true, license_id: 1, body: "Pasta destinada para manuais de uso do Software"})

          generate_article(software, Folder, {name: "Versões Estáveis", slug: "versoes-estaveis", published: true, accept_comments: false, notify_comments: true, license_id: 1, body: "Pasta com os pacotes para download das versões existentes do Software."})

          generate_article(software, TinyMceArticle, {name: "Tutorial de Instalação", body: "<h2>Introdução</h2>\r\n<p>Texto introdutório à página de instalação. Caso tenha-se uma documento específico que possa ser redundante com esta página, remova está página e mantenha apenas o documento. Neste caso, referencie-o adequadamente na página principal do seu software.</p>\r\n<h2>Requisitos</h2>\r\n<p>Texto identificando as dependências e requisitos necessários para a realização da instalação do Software.</p>\r\n<p>Para demonstrar comandos através de terminais utilize a seguinte formatação:</p>\r\n<table style=\"height: 25px; border-color: #000000; background-color: #e7bef7;\" width=\"461\">\r\n\r\n<tr>\r\n<td>\r\n<pre><code><em>$ sudo apt-get install example</em></code></pre>\r\n</td>\r\n</tr>\r\n\r\n</table>\r\n<h2>Passos para instalação</h2>\r\n<p>Crie quantos tópicos forem necessários para melhor explicar a instalação</p>\r\n<h2>Configuração</h2>\r\n<p>Explique todas as configurações necessários para configurar adequadamente outros serviços complementares e do próprio Software.</p>\r\n<h2>Teste da instalação</h2>\r\n<p>Explique os passos para testar se a instalação foi realizada com sucesso.</p>", license_id: 1})

          generate_article(software, TinyMceArticle, {name: "Versões", body: "<p>Texto com detalhamento das mudanças que cada versão do software introduziu. Sugere-se que os arquivos aqui linkados sejam colocados dentro da pasta <a href=\"/software/versoes-estaveis\">Versões Estáveis</a>.</p>\r\n<hr />\r\n<h2> Versão X.Y.C</h2>\r\n<p>Download da <a title=\"Link para arquivo da versão\" href=\"#\">nova versão X.Y.C</a></p>\r\n<ul>\r\n<li>Nova funcionalidade 1</li>\r\n<li>Nova funcionalidade 2</li>\r\n<li>Novo bug resolvido 1</li>\r\n<li>Novo bug resolvido 2</li>\r\n</ul>\r\n<hr />\r\n<h2>Versão X.Y.B</h2>\r\n<p>Lançada <a title=\"Link para o arquivo da nova versão X.Y.B\" href=\"#\">nova versão X.Y.B</a></p>\r\n<ul>\r\n<li>Nova funcionalidade 1</li>\r\n<li>Nova funcionalidade 2</li>\r\n<li>Novo bug resolvido 1</li>\r\n<li>Novo bug resolvido 2</li>\r\n</ul>\r\n<hr />\r\n<h2>Versão X.Y.A</h2>\r\n<p>Download da <a title=\"Link para o arquivo da nova versão X.Y.A\" href=\"#\">nova versão X.Y.A</a></p>\r\n<ul>\r\n<li>Nova funcionalidade 1</li>\r\n<li>Nova funcionalidade 2</li>\r\n<li>Novo bug resolvido 1</li>\r\n<li>Novo bug resolvido 2</li>\r\n</ul>", license_id: 1})

          generate_article(software, TinyMceArticle, {name: "Sobre o #{software.name}", body: "<p>Texto com explicação detalhada sobre o Software. </p>\r\n<p>Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Donec odio. Quisque volutpat mattis eros. Nullam malesuada erat ut turpis. Suspendisse urna nibh, viverra non, semper suscipit, posuere a, pede.</p>\r\n<p>Donec nec justo eget felis facilisis fermentum. Aliquam porttitor mauris sit amet orci. Aenean dignissim pellentesque felis.</p>\r\n<p>Morbi in sem quis dui placerat ornare. Pellentesque odio nisi, euismod in, pharetra a, ultricies in, diam. Sed arcu. Cras consequat.</p>\r\n<p>Praesent dapibus, neque id cursus faucibus, tortor neque egestas augue, eu vulputate magna eros eu erat. Aliquam erat volutpat. Nam dui mi, tincidunt quis, accumsa</p>\r\n<hr />\r\n<h1>Requisitos Mínimos</h1>\r\n<p>Texto curto informativo sobre os requisitos mínimos do software. </p>\r\n<p>Donec nec justo eget felis facilisis fermentum. Aliquam porttitor mauris sit amet orci. Aenean dignissim pellentesque felis. Morbi in sem quis dui placerat ornare. Pellentesque odio nisi, euismod in, pharetra a, ultricies in, diam. Sed arcu. Cras consequa.</p>\r\n<p>Maiores informações podem ser encontradas na <a href=\"/{profile}/tutorial-de-instalacao\">página de instalação</a>.</p>\r\n<hr />\r\n<h1>Novidades da versão X.Y</h1>\r\n<p>Texto informativo sobre as novidades da última versão estável do software. Listar aqui as principais funcionalidades em linhas gerais. Pode-se também ter um link para a página de versões do software, onde terá informações mais detalhadas.</p>\r\n<ul>\r\n<li>Detalhes de uma funcionalidade nova</li>\r\n<li>Detalhes de outra funcionalidade nova</li>\r\n<li>Detalhes sobre um bug corrigido</li>\r\n<li>Detalhes sobre mudanças na interface de usuário</li>\r\n</ul>", license_id: 1 }, true)

          generate_fixed_blocks(software)

          puts "Software Template successfully created!"
        end
      end
    end

    desc "Create new templates of people"
    task :people => :environment do
      Environment.all.each do |env|
        if env.plugin_enabled?("MpogSoftware") or env.plugin_enabled?("SoftwareCommunitiesPlugin")
          person = Person.where(:identifier => "noosfero_person_template").first

          if person.nil?
            password = SecureRandom.hex(6)
            user = User.create!(:name => "People", :login => "people", :email => "person@template.noo", :password => password , :password_confirmation => password, :environment => env)
            person = user.person
          end

          person.layout_template = "leftbar"
          person.is_template = true

          box1 = person.boxes.where(:position => 1).first
          box1.blocks.destroy_all
          person.save!
          puts "Person successfully created!"

          institution_block = InstitutionsBlock.new
          institution_block.position = 4
          institution_block.save!
          box1.blocks << institution_block
          box1.save!
          puts "InstitutionBlock successfully added to person!"

          software_block = SoftwaresBlock.new
          software_block.position = 2
          software_block.save!
          box1.blocks << software_block
          box1.save!
          puts "SoftwaresBlock successfully added to person!"

          community_block = CommunitiesBlock.new
          community_block.position = 3
          community_block.save!
          box1.blocks << community_block
          box1.save!
          puts "CommunitiesBlock successfully added to person!"

          main_block = MainBlock.new
          main_block.position = 1
          main_block.save!
          box1.blocks << main_block
          box1.save!
          puts "MainBlock successfully added to person!"
        end
      end
    end


    desc "Create new templates of community"
    task :community => :environment do
      Environment.all.each do |env|
        if env.plugin_enabled?("MpogSoftware") or env.plugin_enabled?("SoftwareCommunitiesPlugin")
          puts "Community successfully created!"
        end
      end
    end

    desc "Create new templates of intitution"
    task :institution => :environment do
      Environment.all.each do |env|
        if env.plugin_enabled?("MpogSoftware") or env.plugin_enabled?("SoftwareCommunitiesPlugin")
          community = Community.create!(:name => "institution", :is_template => true, :moderated_articles => true, :environment => env)
          community.layout_template = "leftbar"

          box2 = community.boxes.where(:position => 2).first
          box1 = community.boxes.where(:position => 1).first
          box3 = community.boxes.where(:position => 3).first

          box2.blocks.destroy_all
          box1.blocks.destroy_all
          box3.blocks.destroy_all

          community.save!
          puts "Institution succesfully created!"

          members_block = MembersBlock.new
          members_block.limit = 16
          members_block.prioritize_profiles_with_image = true
          members_block.show_join_leave_button = false
          members_block.display_user = "all"
          members_block.language = "all"
          members_block.display = "always"
          members_block.position = 2
          members_block.save!
          box1.blocks << members_block
          box1.save!
          puts "MembersBlock successfully added to institution!"

          main_block = MainBlock.new
          main_block.position = 1
          main_block.save!
          box1.blocks << main_block
          box1.save!
          puts "MainBlock successfully added to institution!"

          generate_fixed_blocks(community)
        end
      end
    end
  end


  desc "Destroy all templates created by this namespace"
  task :destroy => :environment do
    Environment.all.each do |env|
      if env.plugin_enabled?("MpogSoftware") or env.plugin_enabled?("SoftwareCommunitiesPlugin")
        Community["institution"].destroy unless Community["institution"].nil?
        puts "Institution template destoyed with success!"

        Community["software"].destroy unless Community["software"].nil?
        puts "Software template destoyed with success!"

        user = User["people"]
        if !user.nil?
          user.person.destroy
          user.destroy
          puts "Person template destroyed with success!"
        end
      end
    end
  end

  private

  def generate_article(software, klass, params, home_page = false)
    article = klass.new(params)
    article.body = params[:body]

    software.articles << article
    if home_page
      software.home_page = article
    end

    software.save!

    puts "#{params[:name]} #{klass} successfully created!"
  end

  def generate_fixed_blocks(profile)
    identifier = "spb"

    community = Community[identifier]

    if community
      box2 = profile.boxes.where(:position => 2).first

      first_link_list_block = LinkListBlock.new
      first_link_list_block.position = 3
      first_link_list_block.display = "always"
      first_link_list_block.title = "Portal do SPB"
      first_link_list_block.fixed = true
      first_link_list_block.save!

      first_link_list_block.links << {:icon => "no-icon", :name => "Sobre o Portal", :address => "/#{identifier}/sobre-o-portal", :target => "_self"}
      first_link_list_block.links << {:icon => "no-icon", :name => "Notícias", :address => "/#{identifier}/noticias", :target => "_self"}
      first_link_list_block.save!
      box2.blocks << first_link_list_block
      box2.save!
      puts "First LinkListBlock successfully added to software!"

      second_link_list_block = LinkListBlock.new
      second_link_list_block.position = 2
      second_link_list_block.display = "always"
      second_link_list_block.title = "Software Público"
      second_link_list_block.fixed = true
      second_link_list_block.save!

      second_link_list_block.links << {:icon => "no-icon", :name => "Entenda o que é", :address => "/#{identifier}/entenda-o-que-e", :target => "_self"}
      second_link_list_block.links << {:icon => "no-icon", :name => "Inicie um projeto", :address => "/#{identifier}/inicie-um-projeto", :target => "_self"}
      second_link_list_block.links << {:icon => "no-icon", :name => "Publique seu software", :address => "/#{identifier}/publique-seu-software", :target => "_self"}
      second_link_list_block.save!
      box2.blocks << second_link_list_block
      box2.save!
      puts "Second LinkListBlock successfully added to software!"

      third_link_list_block = LinkListBlock.new
      third_link_list_block.position = 1
      third_link_list_block.display = "always"
      third_link_list_block.title = ""
      third_link_list_block.fixed = true
      third_link_list_block.save!

      third_link_list_block.links << {:icon => "no-icon", :name => "Catálogo de Software Público", :address => "/search/software_infos", :target => "_self"}
      third_link_list_block.links << {:icon => "no-icon", :name => "Comunidades", :address => "/search/communities", :target => "_self"}

      third_link_list_block.save!
      box2.blocks << third_link_list_block
      box2.save!
      puts "Third LinkListBlock successfully added to software!"
    else
      puts "IMPOSSIBLE TO CREATE FIXED BLOCKS, THERE IS NO COMMUNITY CALLED SPB"
    end
  end
end
