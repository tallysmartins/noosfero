# encoding: UTF-8
powers = ["Executivo", "Legislativo", "Judiciário", "Não se Aplica"]
spheres = ["Federal", "Estadual", "Distrital", "Municipal"]
jur_natures = ["Administração Direta", "Autarquia", "Empresa Pública", "Fundação",
               "Orgão Autônomo", "Sociedade", "Sociedade Civil",
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
