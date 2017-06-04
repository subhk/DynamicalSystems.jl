#σ = 10.0; ρ = 28.0; β = 8/3;
function lorentz(u0; σ = 10.0, ρ = 28.0, β = 8/3)
  function eom!(du, u)
    du[1] = σ*(u[2]-u[1])
    du[2] = u[1]*(ρ-u[3]) - u[2]
    du[3] = u[1]*u[2] - β*u[3]
    return du
  end
  function jacob!(J, u)
    i = one(eltype(u))
    J[1,1] = -σ*i; J[1,2] = σ*i; J[1,3] = zero(i)
    J[2,1] = ρ*i - u[3]; J[2,2] = -i; J[2,3] = -u[1]
    J[3,1] = u[2]; J[3,2] = u[1]; J[3,3] = -β*i
  end# should give exponents [0.9056, 0, -14.5723]
  return ContinuousDynamicalSystem(u0, eom!, jacob!)
end


#towel map:
@inline function eom_towel(x)
  x1, x2, x3 = x[1], x[2], x[3]
  SVector(3.8*x1*(1-x1)-0.05*(x2+0.35)*(1-2*x3),
  0.1*((x2+0.35)*(1-2*x3)-1 )*(1-1.9*x1),
  3.78*x3*(1-x3)+0.2*x2)
end

function jacob_towel(J, x)
  J[1,1] = 3.8*(1 - 2x[1]); J[1,2] = -0.05*(1-2x[3]); J[1,3] = 0.1*(x[2] + 0.35);
  J[2,1] = 0.19((x[2] + 0.35)*(1-2x[3]) - 1); J[2,2] = 0.1*(1-2x[3])*(1-1.9x[1])
  J[2,3] = -0.2*(x[2] + 0.35)*(1-1.9x[1])
  J[3,1] = 0.0; J[3,2] = 0.2; J[3,3] = 3.78(1-2x[3])
  return J
end
