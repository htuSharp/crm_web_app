# GitHub Pages Deployment Guide

## Prerequisites
1. Create a GitHub account if you don't have one
2. Create a new repository on GitHub named `crm_web_app`

## Step-by-Step Deployment

### 1. Push to GitHub Repository

```bash
# Add your GitHub repository as remote origin
git remote add origin https://github.com/YOUR_USERNAME/crm_web_app.git

# Push to GitHub
git branch -M main
git push -u origin main
```

### 2. Enable GitHub Pages

1. Go to your repository on GitHub
2. Click on **Settings** tab
3. Scroll down to **Pages** in the left sidebar
4. Under **Source**, select **GitHub Actions**
5. The workflow will automatically run and deploy your app

### 3. Update Repository URL

In the `.github/workflows/deploy.yml` file, update the `--base-href` parameter:

```yaml
- name: Build web app
  run: flutter build web --web-renderer html --release --base-href "/YOUR_REPOSITORY_NAME/"
```

Replace `YOUR_REPOSITORY_NAME` with your actual repository name.

### 4. Custom Domain (Optional)

If you want to use a custom domain:

1. In your repository, go to **Settings** > **Pages**
2. Under **Custom domain**, enter your domain
3. Create a CNAME file in the root of your repository with your domain name

## Automatic Deployment

Once set up, the application will automatically deploy to GitHub Pages whenever you:
- Push to the `main` branch
- Merge a pull request to `main`

## Access Your Application

Your app will be available at:
- Default: `https://YOUR_USERNAME.github.io/crm_web_app/`
- Custom domain: `https://yourdomain.com` (if configured)

## Troubleshooting

### Build Fails
- Check that all dependencies are properly installed
- Ensure Flutter version in workflow matches your local version
- Check for any compilation errors in the Actions tab

### Page Not Loading
- Verify the base href is correctly set
- Check browser console for any errors
- Ensure all assets are properly included in the build

### 404 Errors
- Make sure the repository name matches the base href
- Check that GitHub Pages is enabled and source is set to GitHub Actions

## Manual Build and Deploy

If you prefer manual deployment:

```bash
# Build the app
flutter build web --web-renderer html --release --base-href "/your-repo-name/"

# The built files will be in build/web/
# Upload these files to your hosting service
```

## Environment-Specific Configurations

For different environments, you can create multiple workflow files:
- `deploy-staging.yml` for staging deployment
- `deploy-production.yml` for production deployment

Each can have different base href configurations and deployment targets.
