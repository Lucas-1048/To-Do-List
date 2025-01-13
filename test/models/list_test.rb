require "test_helper"

class ListTest < ActiveSupport::TestCase
  test "não deve salvar lista sem título" do
    list = List.new(category: "Pessoal", date: Date.today, user_id: users(:one))
    assert_not list.save, "Salvou a lista sem título"
  end

  test "não deve salvar lista com título maior que 30 caracteres" do
    list = List.new(title: "a" * 31, category: "Trabalho", date: Date.today, user: users(:one))
    assert_not list.save, "Salvou a lista com título maior que 30 caracteres"
  end

  test "deve salvar lista com título válido" do
    list = List.new(title: "Minha Lista", category: "Escola", date: Date.today, user: users(:one))
    assert list.save, "Falhou ao salvar a lista com um título válido"
  end

  test "não deve salvar lista com categoria inválida" do
    list = List.new(title: "Título Válido", category: "Categoria Inválida", date: Date.today, user: users(:one))
    assert_not list.save, "Salvou a lista com categoria inválida"
  end

  test "deve salvar lista com formato de data válido" do
    list = List.new(title: "Título Válido", category: "Pessoal", date: Date.today, user: users(:one))
    assert list.save, "Falhou ao salvar a lista com um formato de data válido"
  end

  # Teste de associação com o usuário
  test "deve pertencer a um usuário" do
    list = List.new(title: "Título Válido", category: "Pessoal", date: Date.today, user: users(:one))
    assert list.save, "A lista deve pertencer a um usuário"
  end

  # Teste de associação com tarefas
  test "deve excluir tarefas quando a lista for deletada" do
    list = lists(:one)
    task_count = list.tasks.count
    list.destroy
    assert_equal 0, Task.where(list_id: list.id).count, "As tarefas não foram excluídas quando a lista foi deletada"
  end
end
