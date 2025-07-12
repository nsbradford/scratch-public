import { NextResponse } from 'next/server';
import type { LeaderboardData } from '@/types/api';

export async function GET(request: Request) {
  const { searchParams } = new URL(request.url);
  const startDate = searchParams.get('startDate');
  const endDate = searchParams.get('endDate');
  
  const now = Math.floor(Date.now() / 1000);
  const twoYearsAgo = now - (2 * 365 * 24 * 60 * 60);
  
  const start = startDate ? Math.floor(new Date(startDate).getTime() / 1000) : twoYearsAgo;
  const end = endDate ? Math.floor(new Date(endDate).getTime() / 1000) : now;
  
  const oneDayInSeconds = 24 * 60 * 60;
  const timestamps: number[] = [];
  const dayCount = Math.ceil((end - start) / oneDayInSeconds);
  
  for (let i = 0; i < dayCount; i++) {
    timestamps.push(start + (i * oneDayInSeconds));
  }

  const generateTrendingData = (baseValue: number, trend: number, volatility: number) => {
    return timestamps.map((_, index) => {
      const trendValue = baseValue + (trend * index / dayCount);
      const noise = (Math.random() - 0.5) * volatility;
      return Math.max(0, Math.round(trendValue + noise));
    });
  };

  const active_repos = timestamps.map((_, index) => {
    const baseRepos = 800;
    const growth = 1200; // Total growth over period
    const trendValue = baseRepos + (growth * index / dayCount);
    const noise = (Math.random() - 0.5) * 100;
    return Math.max(500, Math.round(trendValue + noise));
  });

  const data: LeaderboardData = {
    timestamps,
    active_repos,
    tools: {
      "github-actions[bot]": generateTrendingData(300, 400, 50),
      "dependabot[bot]": generateTrendingData(250, 200, 40),
      "renovate[bot]": generateTrendingData(120, 150, 30),
      "coderabbitai[bot]": generateTrendingData(80, 180, 25),
      "codecov[bot]": generateTrendingData(70, 120, 20),
      "sonarcloud[bot]": generateTrendingData(50, 80, 15),
      "ellipsis-dev[bot]": generateTrendingData(30, 70, 12)
    }
  };

  return NextResponse.json(data);
}
