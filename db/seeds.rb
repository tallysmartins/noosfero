# encoding: UTF-8
powers = ["Executivo", "Legislativo", "Judiciario", "Não se aplica"]
spheres = ["Federal", "Estadual", "Distrital", "Municipal"]
jur_natures = ["Administracao Direta", "Autarquia", "Empresa Publica", "Fundacao",
               "Orgao Autonomo", "Sociedade", "Sociedade Civil",
               "Sociedade de Economia Mista"
              ]

powers.each do |power|
  GovernmentalPower.create(:name => power)
end

spheres.each do |sphere|
  GovernmentalSphere.create(:name => sphere)
end

jur_natures.each do |jur_nature|
  JuridicalNature.create(:name => jur_nature)
end
