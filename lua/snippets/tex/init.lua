for _, v in ipairs {
  'preamble',
  'segments',
  'lists',
  'normalzone_convenieces',
  'environments',
  'math',
} do
  require('snippets.tex.' .. v)
end

-- TODO: delimiters, norm, set <20-03-22, kunzaatko>
-- TODO: matrices <20-03-22, kunzaatko>
-- TODO: sum lim prod int symbols with different indexings <20-03-22, kunzaatko>
-- TODO: fraction snippets <20-03-22, kunzaatko>
-- TODO: squared cubed <20-03-22, kunzaatko>
-- TODO: powers <20-03-22, kunzaatko>
-- TODO: xnn, ynn, xii, yii, yjj <20-03-22, kunzaatko>
-- TODO: R0+ <20-03-22, kunzaatko>
-- TODO: mcal, mbb <20-03-22, kunzaatko>
-- TODO: auto prepend \ (sin and friends) <20-03-22, kunzaatko>
-- TODO: Align and friends <20-03-22, kunzaatko>
-- TODO: Add function that adds by specs table and function... It repeats everywhere <29-09-22, kunzaatko>
