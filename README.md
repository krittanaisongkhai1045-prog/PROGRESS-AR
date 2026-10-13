# Modeva Progress

เว็บติดตามความคืบหน้างานก่อสร้างรายตึก (กระเบื้อง / ฝ้า / พื้น SPC และงานอื่นที่เพิ่มเองได้)
เป็นเว็บหน้าเดียว (`index.html`) เก็บข้อมูลในไฟล์ `data.json` ใน repo นี้ ไม่ต้องมีเซิร์ฟเวอร์

## วิธีติดตั้ง

1. สร้าง repo ใหม่ใน GitHub (เช่น `modeva-progress`)
2. อัปโหลดไฟล์ทั้งหมดในโฟลเดอร์นี้ (`index.html`, `data.json`, `.nojekyll`, `README.md`) ไว้ที่ราก (root) ของ branch `main`
3. เปิด GitHub Pages: Settings → Pages → Source: *Deploy from a branch* → Branch: `main` / `(root)` → Save
4. รอประมาณ 1 นาที จะได้ลิงก์ `https://<username>.github.io/<repo>/`

## ให้แก้ไขข้อมูลได้จากหน้าเว็บ

หน้าเว็บบันทึกข้อมูลโดย commit ไฟล์ `data.json` ผ่าน GitHub API ต้องใช้ token ของแต่ละคน

1. GitHub → Settings → Developer settings → Personal access tokens → *Fine-grained tokens* → Generate new token
2. Repository access: เลือกเฉพาะ repo นี้ / Permissions → Repository permissions → **Contents: Read and write**
3. เปิดเว็บ กดปุ่ม **เชื่อม GitHub** มุมขวาบน ใส่ username, ชื่อ repo, branch และ token แล้วบันทึก
4. ทุกครั้งที่แก้สถานะ เว็บจะ commit ใหม่ให้อัตโนมัติ (รอประมาณ 1 วินาทีหลังแก้) ย้อนดูประวัติได้ใน tab Commits

คนที่ไม่ได้ใส่ token จะเห็นข้อมูลแบบดูอย่างเดียว

## ข้อควรรู้

- repo แบบ public ทำให้ทุกคนที่มีลิงก์เห็นข้อมูลได้ ถ้าต้องการจำกัดผู้เข้าชม ต้องใช้ GitHub Pages แบบ private ซึ่งมีเฉพาะบางแผนของ GitHub
- token เก็บใน localStorage ของเบราว์เซอร์เครื่องนั้นเท่านั้น อย่าใช้เครื่องสาธารณะ และกด "ล้าง token" เมื่อเลิกใช้
- ถ้า 2 คนแก้พร้อมกัน ระบบจะอ่านข้อมูลล่าสุดแล้วบันทึกซ้ำให้ ช่องที่ 2 คนแก้ตรงกันจะเป็นค่าของคนที่บันทึกทีหลัง
- ผู้ที่ไม่ใส่ token จะเห็นข้อมูลล่าช้าได้ถึงไม่กี่นาที เพราะ GitHub Pages มี cache
- ส่งออก PDF/ภาพ: ปุ่ม "ส่งออก" ในหน้าภาพรวม หน้างาน และแต่ละรายการ (เลือกแนวนอน/แนวตั้ง และ A4/A3 ได้)
- สถานะที่ใช้ตัวเลข % สรุปตั้งค่าได้ที่ปุ่ม "ตั้งค่างาน" ของแต่ละงาน
