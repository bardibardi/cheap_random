def play
  s = CheapRandom::random_string(rand(10000))
  x = s + 'X'
  ip = CheapRandom::random_perm
  CheapRandom::cheap_random5(true, ip, s, 0, s.length)
  CheapRandom::cheap_random5(false, ip, s, 0, s.length)
  s == x[0...(s.length)]
end

