require "test_helper"

class TaskTest < ActiveSupport::TestCase
  test "deve salvar uma tarefa válida" do
    task = Task.new(description: "Tarefa Válida", checked: false, list: lists(:one))
    assert task.save, "Falhou ao salvar uma tarefa válida"
  end

  test "não deve salvar uma tarefa sem descrição" do
    task = Task.new(description: nil, checked: false, list: lists(:one))
    assert_not task.save, "Salvou a tarefa sem uma descrição"
  end

  test "não deve salvar uma tarefa com descrição em branco" do
    task = Task.new(description: "", checked: false, list: lists(:one))
    assert_not task.save, "Salvou a tarefa com uma descrição em branco"
  end

  test "não deve salvar uma tarefa com descrição menor que 1 caractere" do
    task = Task.new(description: "", checked: false, list: lists(:one))
    assert_not task.save, "Salvou a tarefa com uma descrição menor que 1 caractere"
  end

  test "não deve salvar uma tarefa com descrição maior que 50 caracteres" do
    task = Task.new(description: "a" * 51, checked: false, list: lists(:one))
    assert_not task.save, "Salvou a tarefa com uma descrição maior que 50 caracteres"
  end

  test "não deve salvar uma tarefa sem valor para checked" do
    task = Task.new(description: "Tarefa Válida", checked: nil, list: lists(:one))
    assert_not task.save, "Salvou a tarefa sem um valor para checked"
  end

  test "deve salvar uma tarefa com checked como true" do
    task = Task.new(description: "Tarefa Válida", checked: true, list: lists(:one))
    assert task.save, "Falhou ao salvar uma tarefa com checked definido como true"
  end

  test "deve salvar uma tarefa com checked como false" do
    task = Task.new(description: "Tarefa Válida", checked: false, list: lists(:one))
    assert task.save, "Falhou ao salvar uma tarefa com checked definido como false"
  end

  test "não deve salvar uma tarefa sem lista associada" do
    task = Task.new(description: "Tarefa Válida", checked: false, list: nil)
    assert_not task.save, "Salvou a tarefa sem uma lista associada"
  end
end
