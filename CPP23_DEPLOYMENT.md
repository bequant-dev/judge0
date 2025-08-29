# Judge0 with GCC 13 and C++20 Support

This is a custom fork of Judge0 that includes GCC 13 with full C++20 support.

## What's Changed

### 1. Dockerfile Modifications
- Updated base image to Ubuntu 22.04 with Ubuntu toolchain PPA
- Installed GCC 13, G++ 13, and GFortran 13 from PPA
- Created symbolic links to `/usr/local/gcc-13.0.0/` for consistency
- Added all necessary Judge0 dependencies (Ruby, Node.js, PostgreSQL, Redis)

### 2. Language Configuration
- Added new C++ language entry with ID 90 (last in the list)
- Configured to use `-std=c++20` by default
- Named "C++ (GCC 13.0.0) - C++20" for clarity

### 3. BeQuant Integration
- Updated API route to use language ID 90 for C++
- Changed compiler flags from `-std=c++17` to `-std=c++20`

## Deployment to Railway

### Prerequisites
1. Install Railway CLI: `npm install -g @railway/cli`
2. Login to Railway: `railway login`
3. Create a new Railway project

### Deployment Steps

1. **Initialize Railway project:**
   ```bash
   cd judge0
   railway init
   ```

2. **Deploy to Railway:**
   ```bash
   railway up
   ```

3. **Get your Railway URL:**
   ```bash
   railway domain
   ```

### Environment Variables

Set these in your Railway project:
- `POSTGRES_HOST`: Your PostgreSQL host
- `POSTGRES_DB`: Database name
- `POSTGRES_USER`: Database user
- `POSTGRES_PASSWORD`: Database password
- `REDIS_PASSWORD`: Redis password

## Testing C++20 Support

Use the included test file `test-cpp23.cpp` to verify C++20 features:

```bash
# Test locally
g++ -std=c++20 test-cpp23.cpp -o test-cpp23
./test-cpp23

# Test via Judge0 API
curl -X POST "https://your-railway-app.railway.app/submissions" \
  -H "Content-Type: application/json" \
  -d '{
    "language_id": 90,
    "source_code": "base64_encoded_source_code",
    "stdin": ""
  }'
```

## Cost Estimation

Railway pricing for this setup:
- **Basic plan**: $5/month (1GB RAM, 1 vCPU) - Sufficient for testing
- **Standard plan**: $20/month (2GB RAM, 2 vCPU) - Recommended for production
- **Pro plan**: $40/month (4GB RAM, 4 vCPU) - For high traffic

## Migration from RapidAPI

1. Deploy this custom Judge0 instance
2. Update your BeQuant `.env.local`:
   ```env
   JUDGE0_SELF_HOSTED_URL=https://your-railway-app.railway.app
   # Remove or comment out JUDGE0_API_KEY
   ```

3. Update your API route to use the self-hosted endpoint

## C++20 Features Available

- `std::format` (C++20)
- `std::ranges` (C++20)
- `std::coroutine` (C++20)
- `std::expected` (C++23)
- `std::flat_map` and `std::flat_set` (C++23)
- `std::generator` (C++23)
- And many more...

## Troubleshooting

### Common Issues

1. **Build fails**: Ensure you have sufficient memory allocated to Railway
2. **Database connection**: Check PostgreSQL credentials in Railway environment
3. **Redis connection**: Verify Redis password is set correctly

### Logs
```bash
railway logs
```

### SSH into container
```bash
railway shell
```
