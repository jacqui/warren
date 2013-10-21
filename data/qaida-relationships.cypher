MATCH (a:Person),(b:Group)
WHERE a.group = 'Al-Qaida' AND b.name = 'AL-QAIDA'
CREATE a-[r:MEMBER_OF]->b
RETURN r;

MATCH (a:Group),(b:Group)
WHERE a.parent_group_name = 'Al-Qaida' AND b.name = 'AL-QAIDA'
CREATE b-[r:PARENT_GROUP]->a
RETURN r;



