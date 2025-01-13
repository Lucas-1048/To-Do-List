require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    sign_in @user
  end

  test "deve acessar a página inicial" do
    get root_path
    assert_response :success
  end

  test "deve acessar a página de nova lista" do
    get new_home_path(date: Date.today)
    assert_response :success
  end

  test "deve acessar a página de edição da lista" do
    get edit_home_path(lists(:one))
    assert_response :success
  end

  test "deve redirecionar após criar uma lista" do
    post home_index_path, params: {
      list: {
        title: "Nova Lista",
        category: "Pessoal",
        date: Date.today,
        tasks: {
          "0" => { description: "Tarefa 1", checked: false }
        }
      }
    }
    assert_redirected_to root_path
  end

  test "deve redirecionar para a página de nova lista quando criação falhar" do
    post home_index_path, params: {
      list: {
        title: "",
        category: "Pessoal",
        date: Date.today,
        tasks: {}
      }
    }
    assert_redirected_to new_home_path
  end

  test "deve redirecionar após atualizar uma lista" do
    put home_path(lists(:one)), params: {
      list: {
        title: "Lista Atualizada",
        category: "Trabalho",
        tasks: {
          "0" => { id: lists(:one).tasks.first.id, description: "Tarefa Atualizada", checked: true }
        }
      }
    }
    assert_redirected_to root_path
  end

  test "deve redirecionar para a página de edição quando atualização falhar" do
    put home_path(lists(:one)), params: {
      list: {
        title: "",
        category: "Trabalho",
        tasks: { "0" => { description: "", checked: false } }
      }
    }
    assert_redirected_to edit_home_path(lists(:one))
  end

  test "deve redirecionar após deletar uma lista" do
    delete home_path(lists(:one))
    assert_redirected_to root_path
  end
end
