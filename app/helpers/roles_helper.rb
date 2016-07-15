module RolesHelper
  def status(role)
    role.active? ? "Active" : "Desactivated"
  end
end
