# Shopping Mall (Flutter Web)

미용재료 쇼핑몰을 **Flutter Web** 중심으로 운영하는 프로젝트입니다. 관리자와 고객 화면이 분리되어 있고, Supabase 인증을 사용합니다.

**Preview**

```mermaid
flowchart LR
  A[Guest] -->|Login| B[Supabase Auth]
  B -->|role=admin| C[Admin Area]
  B -->|role=user| D[Customer Area]
  C --> C1[/admin/dashboard]
  C --> C2[/admin/orders]
  C --> C3[/admin/users]
  D --> D1[/]
  D --> D2[/categories]
  D --> D3[/cart]
  D --> D4[/profile]
```

**Stack**
- Flutter (Web-first)
- Supabase Auth + Database
- Vercel Deployment
- GoRouter + Riverpod

**Routes**
- `/login` 로그인
- `/admin/dashboard` 관리자 대시보드
- `/admin/orders` 주문 관리
- `/admin/users` 유저/권한 관리
- `/` 홈
- `/categories` 카테고리
- `/cart` 장바구니
- `/profile` 마이페이지

**Auth Rules**
- 로그인 후 `role=admin`이면 `/admin/*`만 접근 가능
- 일반 유저는 `/admin/*` 접근 시 `/`로 리다이렉트
- 관리자는 `user_metadata.role = "admin"` 설정 필요

**Quick Start**
```bash
flutter pub get
flutter run -d chrome
```

**Build & Deploy (Vercel)**
```bash
flutter build web --release
vercel --prod --yes build/web
```

**CI/CD**
- GitHub Actions: `main` 브랜치 push 시 자동 배포
- Workflow: `.github/workflows/vercel-deploy.yml`
- Secrets 필요: `VERCEL_TOKEN`, `VERCEL_ORG_ID`, `VERCEL_PROJECT_ID`

**Project Structure**
```text
lib/
  src/
    core/          # router, shell
    features/
      auth/        # login, role
      admin_dashboard/
      products/
      users/
```
