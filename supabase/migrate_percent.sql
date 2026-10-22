-- Migration: งานกระเบื้องส่วนกลางกรอกเป็น % ได้
-- ใช้กับฐานข้อมูลที่นำเข้า data.json เวอร์ชันก่อนหน้าไปแล้ว (ไม่ลบข้อมูลที่แก้ไว้ในรายการอื่น)
-- Supabase Dashboard -> SQL Editor -> วางทั้งไฟล์ -> Run

-- 1) ทางเดิน (Corridor) และบันไดหลัก: เปลี่ยนเป็นแบบ %  (เสร็จแล้วและขั้นหลังจากนั้น = 100, ที่เหลือ = 0)
update public.docs d
   set data = d.data || jsonb_build_object(
         'kind', 'percent',
         'cells', (select coalesce(jsonb_object_agg(e.key,
                    case when jsonb_typeof(e.value) = 'number' then e.value
                         when e.value #>> '{}' in ('เสร็จแล้ว','CM OPEN','CM CLOSE','QC2 OPEN','QC2 CLOSE') then to_jsonb(100)
                         when e.value #>> '{}' = '-' then e.value
                         else to_jsonb(0) end), '{}'::jsonb)
                    from jsonb_each(d.data -> 'cells') e)),
       updated_at = now()
 where d.col = 'grids'
   and d.id in ('tile__D__8','tile__D__9','tile__E__8','tile__E__9','tile__F__8','tile__F__9','tile__G__8','tile__G__9');

-- 2) ชั้นดาดฟ้า (ส่วนกลาง) ของตึก D-G ค่าเริ่มต้นจาก Excel (ถ้ามีอยู่แล้วจะไม่ทับ)
insert into public.docs (col, id, data) values
('grids','tile__D__10','{"work": "tile", "building": "D", "item": "ชั้นดาดฟ้า (ส่วนกลาง)", "order": 10, "floors": [1], "cols": ["กระเบื้องผนัง LA1b", "กระเบื้องพื้น LA1a", "พื้นไม้เทียม", "ผนังไม้เทียม"], "cells": {"1-กระเบื้องผนัง LA1b": 20, "1-กระเบื้องพื้น LA1a": 0, "1-พื้นไม้เทียม": 0, "1-ผนังไม้เทียม": 20}, "kind": "percent", "rowLabel": "ส่วนกลาง", "cw": 96}'::jsonb),
('grids','tile__E__10','{"work": "tile", "building": "E", "item": "ชั้นดาดฟ้า (ส่วนกลาง)", "order": 10, "floors": [1], "cols": ["กระเบื้องผนัง LA1b", "กระเบื้องพื้น LA1a", "พื้นไม้เทียม", "ผนังไม้เทียม"], "cells": {"1-กระเบื้องผนัง LA1b": 35, "1-กระเบื้องพื้น LA1a": 0, "1-พื้นไม้เทียม": 100, "1-ผนังไม้เทียม": 95}, "kind": "percent", "rowLabel": "ส่วนกลาง", "cw": 96}'::jsonb),
('grids','tile__F__10','{"work": "tile", "building": "F", "item": "ชั้นดาดฟ้า (ส่วนกลาง)", "order": 10, "floors": [1], "cols": ["กระเบื้องผนัง LA1b", "กระเบื้องพื้น LA1a", "พื้นไม้เทียม", "ผนังไม้เทียม"], "cells": {"1-กระเบื้องผนัง LA1b": 0, "1-กระเบื้องพื้น LA1a": 0, "1-พื้นไม้เทียม": 30, "1-ผนังไม้เทียม": 0}, "kind": "percent", "rowLabel": "ส่วนกลาง", "cw": 96}'::jsonb),
('grids','tile__G__10','{"work": "tile", "building": "G", "item": "ชั้นดาดฟ้า (ส่วนกลาง)", "order": 10, "floors": [1], "cols": ["กระเบื้องผนัง LA1b", "กระเบื้องพื้น LA1a", "พื้นไม้เทียม", "ผนังไม้เทียม"], "cells": {"1-กระเบื้องผนัง LA1b": 0, "1-กระเบื้องพื้น LA1a": 0, "1-พื้นไม้เทียม": 30, "1-ผนังไม้เทียม": 0}, "kind": "percent", "rowLabel": "ส่วนกลาง", "cw": 96}'::jsonb)
on conflict (col, id) do nothing;
