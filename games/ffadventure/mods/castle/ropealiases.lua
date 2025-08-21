-- ===================================================================

local sra = ocutil.safe_register_alias

-- ===================================================================

sra ("castle:ropebox"               ,
      "ropes:steel1rope_block"      )

sra ("castle:ropesegment"           ,
      "ropes:ropesegment"           )

sra ("castle:rope_bottom"           ,
      "ropes:rope_bottom"           )

-- ===================================================================

sra ("castle:box_rope"              ,
      "ropes:rope"                  )

sra ("castle:rope"                  ,
      "ropes:rope"                  )

sra ("castle:ropes"                 ,
      "ropes:rope"                  )

-- ===================================================================

sra ("castle:ropeladder"            ,
      "ropes:ropeladder"            )

sra ("castle:ropeladder_bottom"     ,
      "ropes:ropeladder_bottom"     )

sra ("castle:ropeladder_falling"    ,
      "ropes:ropeladder_falling"    )

sra ("castle:ropeladder_top"        ,
      "ropes:ropeladder_top"        )

-- ===================================================================

-- Note: In some cases,  the  2nd node in one of the  "sra" calls here
-- won't exist.  This isn't a problem as the "sra" operation is simply
-- skipped in such cases.

for i=1,9 do
    sra (string.format ("castle:%irope_block"       , i) ,
         string.format ( "ropes:%irope_block"       , i))

    sra (string.format ("castle:copper%irope_block" , i) ,
         string.format ( "ropes:copper%irope_block" , i))

    sra (string.format ("castle:steel%irope_block"  , i) ,
         string.format ( "ropes:steel%irope_block"  , i))

    sra (string.format ("castle:wood%irope_block"   , i) ,
         string.format ( "ropes:wood%irope_block"   , i))
end

-- ===================================================================
-- End of file.
