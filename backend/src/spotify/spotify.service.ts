import { Injectable } from '@nestjs/common';

type SpotifyTrack = {
  id: string;
  name: string;
  artists: { name: string }[];
  album: { images: { url: string }[] };
};

@Injectable()
export class SpotifyService {
  private async getAccessToken(): Promise<string> {
    const credentials = Buffer.from(
      `${process.env.SPOTIFY_CLIENT_ID}:${process.env.SPOTIFY_CLIENT_SECRET}`,
    ).toString('base64');

    const response = await fetch('https://accounts.spotify.com/api/token', {
      method: 'POST',
      headers: {
        Authorization: `Basic ${credentials}`,
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: 'grant_type=client_credentials',
    });

    const text = await response.text();
    console.log('Token response:', text);
    const data = JSON.parse(text) as { access_token: string };
    return data.access_token;
  }

  extractTrackId(url: string): string | null {
    const match = url.match(/track\/([a-zA-Z0-9]+)/);
    return match ? match[1] : null;
  }

  async getTrackInfo(trackId: string): Promise<{
    id: string;
    name: string;
    artists: string[];
    albumImage: string;
    spotifyUrl: string;
    popularity: number;
  }> {
    const token = await this.getAccessToken();

    const response = await fetch(
      `https://api.spotify.com/v1/tracks/${trackId}`,
      {
        headers: {
          Authorization: `Bearer ${token}`,
        },
      },
    );

    const text = await response.text();

    const track = JSON.parse(text) as SpotifyTrack;

    return {
      id: track.id,
      name: track.name,
      artists: track.artists.map((a) => a.name),
      albumImage: track.album.images[0]?.url ?? '',
      spotifyUrl: `https://open.spotify.com/track/${track.id}`,
      popularity: 0,
    };
  }
}
