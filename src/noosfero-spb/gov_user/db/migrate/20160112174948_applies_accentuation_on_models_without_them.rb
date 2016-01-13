#encoding: utf-8

class AppliesAccentuationOnModelsWithoutThem < ActiveRecord::Migration
  def up
    execute "UPDATE governmental_powers SET name = 'Judiciário' WHERE name = 'Judiciario'"
    execute "UPDATE governmental_powers SET name = 'Não se Aplica' WHERE name = 'Nao se Aplica'"

    execute "UPDATE juridical_natures SET name = 'Administração Direta' WHERE name = 'Administracao Direta'"
    execute "UPDATE juridical_natures SET name = 'Empresa Pública' WHERE name = 'Empresa Publica'"
    execute "UPDATE juridical_natures SET name = 'Fundação' WHERE name = 'Fundacao'"
    execute "UPDATE juridical_natures SET name = 'Orgão Autônomo' WHERE name = 'Orgao Autonomo'"
  end

  def down
    say "This migration has no back state"
  end
end
